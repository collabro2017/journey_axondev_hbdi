# Flow

## Starting Nerve
* Call Nerve.init to setup initial configuration
* Call Class.subscribe for all the listeners you want never to handle
* Call Nerve.work to start the listening threads and then continue program execution
  * Nerve.work spins up a new thread and runs PollingManager#begin_polling in that thread and then continues with the next line of code
  * Nerve.work spins up a new thread and runs ParkedPollingManager#begin_polling in that thread and then continues with the next line of code

# In the PollingManager#begin_polling thread
* The Polling manager begins to loop through the subscriptions
* For the first subscription it spins off a separate thread to run Poller#poll(subscription) for a given subscription
  * Number of polling threads determined by the size of the :pollers pool
* It stores a Celluloid::Future for this thread in subscription_status_map so we can keep track of what polling threads are still running

* If PollingManager#stop has been called it breaks out of the loop and the thread exits

* If not it starts the loop again to process the next subscription
  * Before grabbing the next subscription it sleeps for an amount of time determined by the wake interval so other threads can do their processing
  * It also checks to make sure there isn't an incomplete future in subscription_status_map for this subscription already. If there is it skips and moves to the next subscription

# In the Poller#poll thread
* Poller#poll makes an http request to the subscription endpoint and extracts the most recent event
  * If there's no event, the poller completes and the polling thread is closed out
* The poller spins up a new thread to run EventWorker#work
* The poller creates a Celluloid::Future watching the EventWorker#worker thread and registers that future with the WorkerHandler. This way we know how many EventWorkers are out there currently working jobs, and can manage graceful shutdown of those jobs if necessary
* Once registering the Celluloid::Future the polling thread closes out, leaving the EventWorker to finish its work in a separate thread

# In the EventWorker#work thread
* EventWorker#work calls the Subscription#handler method, passing along the event data
  * Prior to calling this method, it will properly setup AR connections for later disposal
* Subscription#handler calls the run method on the listener class, actually performing the business logic
* If the business logic succeeds then EventWorker#work will call Event#ack! which sends an HTTP request to eventstore to acknowledge successful handling of the event
* If the business logic has an exception, then we rescue that exception and call Event#nack! to let eventstore know about the failure so it can queue the job for retry.
* Then we re-raise the exception so the EventWorker#work thread exits with an error which is logged by Celluloid (since it's a separate thread the exception does not stop any of the other threads from executing)

# In the ParkedPollingManager#begin_polling thread
* Works similar to the PollingManager#begin_polling thread, looping through subscriptions and making a call to the subscriptions parked messages stream
  * This is where events that fail processing repeatedly go so they don't hang up the rest of the queue with endless retries

* passes additional arguments off to the ParkeMessagesPoller#poll call that includes that result of the last call to poll so the parked poller can decide what to do

# Stopping Nerve
* In the main thread we call Nerve.stop
* This calls PollingManager#stop
  * Sets an instance variable to let the PollingManager#begin_polling thread know to stop looping and exit
  * Calls Celluloid::Future#value for every future in subscription_status_map. This forces the main thread to wait until all of the Poller#poll threads complete their work before the main thread can continue to the next command
* Then calls WorkerHandler#halting
  * This calls Celluloid::Future#value for every future that was registered with the WorkerHandler by the Poller#poll method. This forces the main thread to allow all the EventWorker#work threads to finish before the main thread can continue to the next command
* This means Nerve.stop will not finish until we've cleaned up all Nerve related threads
