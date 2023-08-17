# Rails URL Shortener

Author: Ang-dot

This is a Ruby on Rails 7 project for a URL shortener.

## Ruby version

This project uses Ruby 2.7.6.

To configure your local to use Ruby 2.7.6, run:
`asdf ruby install 2.7.6`
`asdf local ruby 2.7.6`

## System dependencies

This project uses the following gems:
- `open-uri` for scraping title tag from a URL
- `nokogiri` for parsing HTML
- `geocoder` for detection of user's location
- `rspec-rails` and `factory_bot_rails` for testing

## Configuration

This project uses PostgreSQL for the database.

## Database creation & initialisation

To create the database, run:
`rails db:create`
`rails db:migrate`

## Test

This project uses RSpec for testing. To run the test suite, run:
`rspec`

## Deployment instructions

To start the server, run:
`rails server`
