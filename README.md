# Promptku

This is a web application built by Maurice Cadenhead.

# Setup for development and testing

    cp config/database.example.yml config/database.yml # and edit
    RAILS_ENV=test bundle exec rake db:create
    RAILS_ENV=development bundle exec rake db:setup
    bundle exec rake db:populate


# Run the tests

    bundle exec rake