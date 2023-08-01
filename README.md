# Objective

* The API provides weather information given a zipcode
* It caches the response for 30 minutes and invalidates if there is a recent weather info for that zipcode

# Assumptions

* The API is exposed publicly, no authentication has been implemented
* The current weather of a location is stored in a database instead of being fetched from remote sevices
* The temperatures are assummed to be in only 1 unit, degree Celsius
* High & low temperature are marked/updated daily and are given for a day range
* Extended forecast means air quality, humidity, air pressure, wind speed.
* Expecting zip code as a 5 digit code
* For caching we are using memory store. It will wipe out on restart and also limited cache entries will be stored on memory and LRU

# Linting
We are using Rubocop for lint check.

`bundle exec rubocop`

# SAST Scanner
We are using Brakeman for SAST scanning.

`brakeman`

# Dependency check for vulnerability

`bundle-audit check --update`





This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
