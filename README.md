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

[get /hello/:name - add a parameter to the request](https://github.com/arafatm/Book-Programming-Phoenix/commit/9824626)

### Going Deeper: The Request Pipeline

`Plug` is a function that acts on `conn`. The app is a **pipeline of plugs**

Sample of project dir structure:
- `config/` Phoenix configuration
- `lib/` supervisision trees and long running processes
- `test/`
- `web` code incl. model, view, template, controller

`web` vs `lib`
- web is **live reloaded**
- lib is for services, PubSub, DB conn pool, supervised procs

Elixir Configuration: sample files
- ├── lib
- │   ├── hello
- │   │   ├── endpoint.ex
- │   │   └── ...
- │   └── hello.ex        # start/stop/supervise app
- ├── mix.exs             # main configuration file. Include deps
- ├── mix.lock            # after compilation includes dep versions
- ├── test

`.ex` files are compiled into `.beam`. `.exs` are not

Environment & endpoints
- ├── config
- │   ├── config.exs    # app config
- │   ├── dev.exs
- │   ├── prod.exs
- │   ├── prod.secret.exs # secrets e.g. passwords
- │   └── test.exs

`config/config.exs` defines endpoints, logging, etc.

e.g. [line 13 defines the 
Endpoint](https://github.com/arafatm/Book-Programming-Phoenix/blob/090ae4ee0fc1dd40aed91a66d95ac627c47fd8af/hello/config/config.exs)
which points to 
[lib/hello.endpoints.ex](https://github.com/arafatm/Book-Programming-Phoenix/blob/090ae4ee0fc1dd40aed91a66d95ac627c47fd8af/hello/lib/hello/endpoint.ex)

Typical Phoenix app looks like
```
connection
|> endpoint     # includes functions for every request
|> router
|> pipeline     # common functions for each major type of request
|> controller   # invokes model and render template
```

## Chapter 3: Controllers, Views, and Templates

### The Controller

Create new Rumbl app
[$ mix phoenix.new rumbl && cd rumbl && mix ecto.create](https://github.com/arafatm/Book-Programming-Phoenix/commit/5e0951e)

[Set "Rumbl.io" on home page](https://github.com/arafatm/Book-Programming-Phoenix/commit/072fde3)

### Creating Some Users

[Model User: id, name, username, password](https://github.com/arafatm/Book-Programming-Phoenix/commit/ab19713)

[Model User access functions](https://github.com/arafatm/Book-Programming-Phoenix/commit/0ab380d)

[Disable Ecto for now](https://github.com/arafatm/Book-Programming-Phoenix/commit/571e9d7)

To Test out
```elixir
iex> alias Rumbl.User
iex> alias Rumbl.Repo

iex> Repo.all User
    [%Rumbl.User{id: '1', name: 'José', password: 'elixir', username: 'josevalim'},
     %Rumbl.User{id: '3', name: 'Chris', password: 'phoenix', username: 'cmccord'},
     %Rumbl.User{id: '2', name: 'Bruce', password: '7langs', username: 'redrapids'}]

iex> Repo.all Rumbl.Other
    []

iex> Repo.get User, '1'
    %Rumbl.User{id: '1', name: 'José', password: 'elixir', username: 'josevalim'}

iex> Repo.get_by User, name: 'Bruce'
    %Rumbl.User{id: '2', name: 'Bruce', password: '7langs', username: 'redrapids'}
```

### Building a Controller

Standard actions: `:show`, `:index`, `:new`, `:create`, `:edit`, `:update`, `:delete`

[UserController get /users](https://github.com/arafatm/Book-Programming-Phoenix/commit/42fc696)

### Coding Views

[get /users display all users and link to user/:id](https://github.com/arafatm/Book-Programming-Phoenix/commit/6969425)
- Fix: [display User.name, not User.username](https://github.com/arafatm/Book-Programming-Phoenix/commit/ae74a65)

### Using Helpers

We can test helpers in `iex`
```elixir
iex> Phoenix.HTML.Link.link('Home', to: '/')
    {:safe, ['<a href=\'/\'>', 'Home', '</a>']}

iex> Phoenix.HTML.Link.link('Delete', to: '/', method: 'delete')
    {:safe,
    [['<form action=\'/\' class=\'link\' method=\'post\'>',
      '<input name=\'_method\' type=\'hidden\' value=\'delete\'>
      <input name=\'_csrf_token\' type=\'hidden\' value=\'UhdjBFUcOh...\'>'],
     ['<a data-submit=\'parent\' href=\'#\'>', '[x]', '</a>'], '</form>']}
```

In views e.g. `web/views/user_view.ex` we see at the top `use Rumbl.Web, :view`

This refers to `def view` in `web/web.ex`

### Showing a User

[get /user/:id](https://github.com/arafatm/Book-Programming-Phoenix/commit/b113020)

Refactor duplication by [render a nested 
template](https://github.com/arafatm/Book-Programming-Phoenix/commit/ce7c5ee)

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
