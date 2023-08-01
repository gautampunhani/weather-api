# Objective

* The API provides weather information given a zipcode
* It caches the response for 30 minutes and invalidates if there is a recent weather info for that zipcode

# Assumptions

* The API is exposed publicly, no authentication has been implemented
* The current weather of a location is stored in a database instead of being fetched from remote sevices
* The temperatures are assumed to be in only 1 unit, degree Celsius
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

# Using in dev environment

1. Run db seed script : `rails db:seed`
2. Enable caching if it is disabled using : `rails dev:cache`
3. Hit http://127.0.0.1:3000/location_weather?zipcode=13271

