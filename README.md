# Spree API Examples

In this repo, you can expect to find some examples of how to interact with Spree's API.

All examples use the Faraday and httpclient gems, as these provide (imo) the best Ruby HTTP API available. Your mileage may vary if you choose to use other gems.

There are not that many examples at the moment. This will change, over time. You can help it change by submitting pull requests to this repo.

## Do these examples work?

Sure they do!

There's a catch, though: you have to run them against a sample store setup using Spree's sample data. You can set one up by installing Spree and then running these commands:

    bundle exec rake db:reset spree_sample:load AUTO_ACCEPT=1

Which is the equivalant of running:

    bundle exec rake db:drop
    bundle exec rake db:create
    bundle exec rake db:migrate
    bundle exec rake db:seed AUTO_ACCEPT=1
    bundle exec rake spree_sample:load --trace

These commands (of course) will kill everything you know and love in your database. If you don't care about the data in your database, run them.

These commands will give you *most* of what you need. One final thing:

    rails console
    Spree::User.first.update_column(:spree_api_key, 'fake')

**Now you're ready to run the tests and be MEGA SUCCESSFUL**.

You can run them in two ways:

    ruby test.rb # this will run them all
    ruby examples/checkout/walkthrough.rb # this will run just the one

## License

Do whatever you want with the source code.

Please tell me if you find it useful. I'm reachable through the usual means.

No implied warranty.

Batteries not included. May dissolve in water. Keep out of reach of children.
