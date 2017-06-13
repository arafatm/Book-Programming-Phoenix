#  Programming Phoenix

# Part 1: Building with Functional MVC

In Part I, well talk about traditional request/response web applications
- basic layers of Phoenix
- structure your application into small functions, with each one transforming the results of the previous ones
- small functions will lead to the controller, from where we call models and views
- new functional take on the existing model-view-controller pattern
- integrate databases through the Ecto persistence layer
- build your own authentication API
- test what youve built so far

In short, youll learn to build traditional applications that are faster, more
reliable, and easier to understand.

## Chapter 2: The Lay of the Land
### Installing Your Development Environment

- elixir 1.1.0
- psql 9.2.1
- node v5.3.0

`$ mix archive.install https://github.com/phoenixframework/archives/raw/`

### Creating a Throwaway Project

```
cd hello

sudo apt-get install erlang-dev erlang-parsetools

sudo -u postgres psql postgres  $ -> \password postgres

apt-get mix phoenix.new hello

mix ecto.create

mix phoenix.server
```

[http://localhost:4000](http://localhost:4000)

### Building a Feature

[get /hello](https://github.com/arafatm/Book-Programming-Phoenix/commit/dd46353)
- Add a route `/hello`
- Add a `controllers/hello_controller.ex`
- Add a `views/hello_view.ex`
- Add a `templates/hello/world.html.eex`

:boom: when you update the template the browser autoreloads

[get /hello/:name - pass a parameter to the controller](https://github.com/arafatm/Book-Programming-Phoenix/commit/9499673)

### Going Deeper: The Request Pipeline
### Wrapping Up

## Chapter 3: Controllers, Views, and Templates
### The Controller
### Creating Some Users
### Building a Controller
### Coding Views
### Using Helpers
### Showing a User
### Wrapping Up

## Chapter 4: Ecto and Changesets
### Understanding Ecto
### Defining the User Schema and Migration
### Using the Repository to Add Data
### Building Forms
### Creating Resources
### Wrapping Up

## Chapter 5: Authenticating Users
### Preparing for Authentication
### Managing Registration Changesets
### Creating Users
### The Anatomy of a Plug
### Writing an Authentication Plug
### Implementing Login and Logout
### Presenting User Account Links
### Wrapping Up

## Chapter 6: Generators and Relationships
### Using Generators
### Building Relationships
### Managing Related Data
### Wrapping Up

## Chapter 7: Ecto Queries and Constraints
### Adding Categories
### Diving Deeper into Ecto Queries
### Constraints
### Wrapping Up

## Chapter 8: Testing MVC
### Understanding ExUnit
### Using Mix to Run Phoenix Tests
### Integration Tests
### Unit-Testing Plugs
### Testing Views and Templates
### Splitting Side Effects in Model Tests
### Wrapping Up

# Part 2: Writing Interactive and Maintainable Applications

## Chapter 9: Watching Videos
### Watching Videos
### Adding JavaScript
### Creating Slugs
### Wrapping Up

## Chapter 10: Using Channels
### The Channel
### Phoenix Clients with ES6
### Preparing Our Server for the Channel
### Creating the Channel
### Sending and Receiving Events
### Socket Authentication
### Persisting Annotations
### Handling Disconnects
### Wrapping Up

## Chapter 11: OTP
### Managing State with Processes
### Building GenServers for OTP
### Supervision Strategies
### Designing an Information System with OTP
### Building the Wolfram Info System
### Wrapping Up

## Chapter 12: Observer and Umbrellas
### Introspecting with Observer
### Using Umbrellas
### Wrapping Up

## Chapter 13: Testing Channels and OTP
### Testing the Information System
### Isolating Wolfram
### Adding Tests to Channels
### Authenticating a Test Socket
### Communicating with a Test Channel
### Wrapping Up

## Chapter 14: Whats Next?
### Other Interesting Features
### Whats Coming Next
### Good Luck

## You May Be Interested In
