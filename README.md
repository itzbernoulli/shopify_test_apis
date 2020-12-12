# Shopify API Test

This is a repository that implements shopify oauth call and gets all customers in a shopify store

A working version of this app can be found on heroku [SHOPIFYLY](https://shopifyly.herokuapp.com/)

This project uses:

* Ruby version - 2.7.0

* Rails version - 6.0.3.4

* External Gems integrated
    * rspec for testing
    * factorybot for test data stubbing
    * faker to generate random user data and support requests

* Packages included with webpack
    * bootstrap
    * bootswatch

* This project require ssl to work in any environment. For localhost follow the [LINK](https://madeintandem.com/blog/rails-local-development-https-using-self-signed-ssl-certificate/) to know the procedure to get certificates and use when running the application.

### Installation procedure
1. clone the project from the Github repo

2. cd into the folder

3. run `bundle install` to install all dependencies

4. run `rails db:create db:migrate` to create, migrate and seed the database, 

5. run `rails s` with your local ssl certificates and take it for a spin.