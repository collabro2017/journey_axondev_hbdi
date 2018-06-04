namespace :background do
  task run_listeners: [:environment] do
    ThinkerUpdated.subscribe

    Nerve.work

    stop = false
    %w( INT TERM ).each do |signal|
      trap(signal) {stop = true}
    end

    at_exit do
      $stdout.puts "Finishing Nerves's current jobs before exiting..."
      Nerve.stop
      $stdout.puts "Nerve's jobs finished, exiting..."
    end

    loop do
      sleep 0.01
      break if stop
    end
  end
end
