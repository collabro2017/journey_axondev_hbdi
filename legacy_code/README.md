# Axon Connect

Axon Connect is the service that is meant to help thinkers control who can see their data and how it's used. It consists of a UI to manage 'connections' to other thinkers to facilitate thinker to thinker sharing and an API used internally by other services when they need to show data from one of a thinker's connections. It may eventually be expanded to support letting users manage giving external applications access to their data to support 3rd party applications.

Axon Connect is built with a rails 5.0 backend and a mostly server side rendered HTML front end with some use of javascript on the front end. All client side assets are built using webpack rather than sprockets to take advantage of the webpack build processes support for modern tooling like ES6, CSS Modules, and occasional use of react. We use the new `webpacker` gem now bundled with rails 5.10beta+ to manage the webpack integration.
