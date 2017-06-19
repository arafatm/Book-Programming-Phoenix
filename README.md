#  Programming Phoenix

[epub](https://github.com/arafatm/Books/blob/master/langs/elixir/programming%20phoenix%20(for%20arafat%20mohamed)_chris%20mcc.epub)

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
    [%Rumbl.User{id: "1", name: "José", password: "elixir", username: "josevalim"},
     %Rumbl.User{id: "3", name: "Chris", password: "phoenix", username: "cmccord"},
     %Rumbl.User{id: "2", name: "Bruce", password: "7langs", username: "redrapids"}]

iex> Repo.all Rumbl.Other
    []

iex> Repo.get User, "1"
    %Rumbl.User{id: "1", name: "José", password: "elixir", username: "josevalim"}

iex> Repo.get_by User, name: "Bruce"
    %Rumbl.User{id: "2", name: "Bruce", password: "7langs", username: "redrapids"}
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
iex> Phoenix.HTML.Link.link("Home", to: "/")
    {:safe, ["<a href=\"/\">", "Home", "</a>"]}

iex> Phoenix.HTML.Link.link("Delete", to: "/", method: "delete")
    {:safe,
    [["<form action=\"/\" class=\"link\" method=\"post\">",
      "<input name=\"_method\" type=\"hidden\" value=\"delete\">
      <input name=\"_csrf_token\" type=\"hidden\" value=\"UhdjBFUcOh...\">"],
     ["<a data-submit=\"parent\" href=\"#\">", "[x]", "</a>"], "</form>"]}
```

In views e.g. `web/views/user_view.ex` we see at the top `use Rumbl.Web, :view`

This refers to `def view` in `web/web.ex`

### Showing a User

[get /user/:id](https://github.com/arafatm/Book-Programming-Phoenix/commit/b113020)

Refactor duplication by [render a nested 
template](https://github.com/arafatm/Book-Programming-Phoenix/commit/ce7c5ee)

## Chapter 4: Ecto and Changesets

### Understanding Ecto

Ecto:
- wraper for RDBMS
- encapsulated query language
- **changesets** 

[Reenable Ecto](https://github.com/arafatm/Book-Programming-Phoenix/commit/9890d0b)

`mix ecto.create` to create the repo

### Defining the User Schema and Migration

1. [Model User - define schema](https://github.com/arafatm/Book-Programming-Phoenix/commit/99b173d)
2. [$ mix ecto.gen.migration create_user](https://github.com/arafatm/Book-Programming-Phoenix/commit/2a04b16)
3. [Screwed up the migration.  Fixed](https://github.com/arafatm/Book-Programming-Phoenix/commit/543c2df)
4. `mix ecto.migrate`

Test out in `iex -S mix`
```
Repo.insert(%User{ name: "José", username: "josevalim", password_hash: "<3<3elixir" })

Repo.all(User)

Repo.get(User, 1)
```

### Using the Repository to Add Data

1.  [UserController.new](https://github.com/arafatm/Book-Programming-Phoenix/commit/5c7e1af)
2.  [User.changeset](https://github.com/arafatm/Book-Programming-Phoenix/commit/8659e94)
3.  [Router: resources "/users"](https://github.com/arafatm/Book-Programming-Phoenix/commit/9ea506f)
4.  [New User form](https://github.com/arafatm/Book-Programming-Phoenix/commit/f186b89)


To view currently defined routes `mix phoenix.routes`

### Creating Resources

1.  [UserController.create](https://github.com/arafatm/Book-Programming-Phoenix/commit/c528d4d)
2. [Handle UserController.create validation errors](https://github.com/arafatm/Book-Programming-Phoenix/commit/a953de1)

## Chapter 5: Authenticating Users

### Preparing for Authentication

Use [Comeonin library](https://github.com/riverrun/comeonin) for hashing

[Add comeonin package to handle password hashing](https://github.com/arafatm/Book-Programming-Phoenix/commit/775faa9)
- [$ mix deps.get](https://github.com/arafatm/Book-Programming-Phoenix/commit/6f7b7fb)


### Managing Registration Changesets

[User.registration_changeset validates and hashes password](https://github.com/arafatm/Book-Programming-Phoenix/commit/f845ddd)

### Creating Users

[UserController use registration_changeset](https://github.com/arafatm/Book-Programming-Phoenix/commit/38f6e04)

### The Anatomy of a Plug

2 types of plugs: function or module

**function plugs**
- provides single function
- e.g. `plug :protect_from_forgery` in `web/router.ex`
- specified with name of function _as atom_

**module plugs**
- provides 2 functions `init` and `call` with some config
- e.g. `plug Plug.Logger` in `lib/rumbl/endpoint.ex`
- specified with _module name_
- `init` is compile-time
- `call` is run-time

template for module plug
```elixir
defmodule MyPlug do
  def init(opts) do         # compile-time and passes opts to call
    opts
  end

  def call(conn, _opts) do  # run time
    conn
  end
end
```

All plugs **receive** a `conn` and **return** a `conn`

`conn` is a [Plug.Conn](https://hexdocs.pm/plug/Plug.Conn.html)

Plug.Conn request fields contain information about *inbound request* e.g.
- `host` e.g. www.pragprog.com
- `method` e.g. GET or POST
- `path_info` path split into list e.g. ["admin", "users"]
- `req_headers` request headers e.g. [{"content-type", "text/plain"}]
- `scheme` request protocol as atom e.g. :https
- others

Plug.conn *fetchable fields* e.g.
- `cookies` req/resp cookies
- `params` parsed from query string or req body

Plug.Conn fields to *process web requests* e.g.
- `assigns` map containing your data
- `halted` flag set when conn is halted e.g. failed authorization
- `state` of the connection e.g. :set, :sent, etc

Plug.Conn *response* fields e.g.
- `resp_body` http response string
- `resp_cookies` outbound cookies
- `resp_headers` HTTP headers e.g. response type, caching, etc
- `status` code e.g. 404

Plug.conn *private* fields e.g.
- `adapter` info
- `private` map for private use

Plug.conn starts *blank* and is filled out progressively by different plugs in 
the pipeline

### Writing an Authentication Plug

[Rumbl.Auth plug to authenticate user](https://github.com/arafatm/Book-Programming-Phoenix/commit/ebb2353)

[Router pipeline add Rumbl.Auth plug](https://github.com/arafatm/Book-Programming-Phoenix/commit/1849c6c)

[UserController authenticate user and restrict acces to :index](https://github.com/arafatm/Book-Programming-Phoenix/commit/cc056d2)

[UserController change authenticate method into a plug function](https://github.com/arafatm/Book-Programming-Phoenix/commit/aa750d9)

:boom: use of `halt()`. Plugs explicitly check for `halted: true` between every 
plug invocation

[Rumbl.Auth.login method to auto-login when a new user is created](https://github.com/arafatm/Book-Programming-Phoenix/commit/75f151b)

### Implementing Login and Logout

[Login implementation](https://github.com/arafatm/Book-Programming-Phoenix/commit/529859e)

### Presenting User Account Links

[App Layout: display logged in user and logout link](https://github.com/arafatm/Book-Programming-Phoenix/commit/cd4c051)

[Implement logout functionality](https://github.com/arafatm/Book-Programming-Phoenix/commit/6dd8e15)

## Chapter 6: Generators and Relationships

### Using Generators

[$ mix phoenix.gen.html Video videos user_id:references:users url:string title:string description:text](https://github.com/arafatm/Book-Programming-Phoenix/commit/7a3726c)

[Route recources /videos](https://github.com/arafatm/Book-Programming-Phoenix/commit/d0dcbea)

`mix ecto.migrate` to update the repository

[Rumbl.Auth.authenticate_user when scope /manage](https://github.com/arafatm/Book-Programming-Phoenix/commit/403ef46)

[ID10t error: Router needs Rumbl.Auth.authenticate_user](https://github.com/arafatm/Book-Programming-Phoenix/commit/e022f6a)

### Building Relationships

[User has_many Video](https://github.com/arafatm/Book-Programming-Phoenix/commit/a79d62a)

Associations are explicit. To ensure associated records are fetched 
`Repo.preload/2`

Another method is to `q = Ecto.assoc/2` to fetch assoc data without storing 
them in primary struct. Then `Repo.all(q)` to get data in its own struct

### Managing Related Data

[Phoenix.Controller has `action/2` that can be overridden](https://hexdocs.pm/phoenix/Phoenix.Controller.html)

[VideoController CRUD with User association](https://github.com/arafatm/Book-Programming-Phoenix/commit/6c74a24)
- :boom: overriding of `action(conn, _)`

## Chapter 7: Ecto Queries and Constraints

### Adding Categories

[$ mix phoenix.gen.model Category categories name:string](https://github.com/arafatm/Book-Programming-Phoenix/commit/dc741bc)

[Migrations.CreateCategory :name is required and unique](https://github.com/arafatm/Book-Programming-Phoenix/commit/7a08b9d)

[Video belongs_to Category && set required/optional fields](https://github.com/arafatm/Book-Programming-Phoenix/commit/9404f06)

[`$ mix ecto.gen.migration add_category_id_to_video`](https://github.com/arafatm/Book-Programming-Phoenix/commit/f9bc4a9)

[migration to add category_id to videos](https://github.com/arafatm/Book-Programming-Phoenix/commit/f547287)

[Migration create category typo](https://github.com/arafatm/Book-Programming-Phoenix/commit/55db277)

`$ mix ecto.migrate`

[Seed categories](https://github.com/arafatm/Book-Programming-Phoenix/commit/434f158)

`$ mix run priv/repo/seeds.exs`

[Seed Category: Check for existing record to avoid inserting duplicate](https://github.com/arafatm/Book-Programming-Phoenix/commit/5265b73)

Example of how to query db with Ecto.Query

```elixir
import Ecto.Query
alias Rumbl.Repo
alias Rumbl.Category

Repo.all from c in Category

Repo.all from c in Category,
  order_by: c.name,
  select: {c.name, c.id}

 # Composable query example
q = Category
q = from c in q, order_by: c.name
q = from c in q, select: {c.name, c.id}
Repo.all q
```

[Category queryables alphabetical && names_and_ids](https://github.com/arafatm/Book-Programming-Phoenix/commit/f952fde)

[Video display Categories](https://github.com/arafatm/Book-Programming-Phoenix/commit/6f1d2ae)

### Diving Deeper into Ecto Queries

Keep functions with **side effects in the controller**. Model and view should 
be side effect free

Writing Ecto queries

```elixir
import Ecto.Query
alias Rumbl.{Repo, User}

username = "arafatm"

Repo.one(from u in User, where: u.username == ^username)

Repo.one from u in User,
  select: count(u.id),
  where: ilike(u.username, ^"a%") or ilike(u.username, ^"c%")

users_count = from u in User, select: count(u.id)

#Can use previous result to keep building on the query

a_users = from u in users_count, where: ilike(u.username, ^"%a%")

Repo.all a_users
```

Queries with Pipe Syntax

```elixir
User |>
select([u], count(u.id)) |>
where([u], ilike(u.username, ^"a%") or ilike(u.username, ^"m%")) |>
Repo.one()
```

Ecto **Fragments** allow construction of a SQL fragment.

```elixir
uname = "arafat"

u = from(u in User,
    where: fragment("lower(username) = ?", ^String.downcase(uname)))

Repo.all(u)
```

Querying Relationships

```elixir
user = Repo.one from(u in User, limit: 1)

user.videos

user = Repo.preload(user, :videos)

user.videos

user = Repo.one from(u in User, limit: 1, preload: [:videos])

user.videos

Repo.all from u in User,
  join: v in assoc(u, :videos),
  join: c in assoc(v, :category),
  where: c.name == "Comedy",
  select: {u, v}
```

### Constraints

Given `create unique_index(:users, [:username])` in the migration CreateUsers 
migration, if we try to create a duplicate user we get a `constraint error ... 
* unique: users_username_index`

The terminal will show a `(Ecto.ConstraintError)`

We can display the error `unique_constraint(:username)` in the User model

[User changeset validates unique_constraint](https://github.com/arafatm/Book-Programming-Phoenix/commit/79bac03)

Similarly we can validate foreign keys with `assoc_constriant(:category)` in 
Video model

[Video assoc_constraint category](https://github.com/arafatm/Book-Programming-Phoenix/commit/c6a7794)

```elixir
alias Rumbl.Category
alias Rumbl.Video
alias Rumbl.Repo
import Ecto.Query
category = Repo.get_by Category, name: "Drama"
video = Repo.one(from v in Video, limit: 1)

#Test valid category
changeset = Video.changeset(video, %{category_id: category.id})
Repo.update(changeset)

#Test invalid category
changeset = Video.changeset(video, %{category_id: 12345})
Repo.update(changeset)

#inspect error changeset
{:error, changeset} = v(-1)
changeset.errors
```

:boom: [Display errors on view](https://github.com/arafatm/Book-Programming-Phoenix/commit/b4d61d8)

## Chapter 8: Testing MVC

### Using Mix to Run Phoenix Tests

**Set up continuous testing**
- [Continuous testing with mix test watch](https://github.com/arafatm/Book-Programming-Phoenix/commit/d2f1d63)
-[Clear terminal on each test run](https://github.com/arafatm/Book-Programming-Phoenix/commit/ac8644c)
- `mix deps.update`
- `mix test.watch`

Delete VideoControllerTest for now
[delete VideoControllerTest](https://github.com/arafatm/Book-Programming-Phoenix/commit/7378ed8)

Fix failing PageControllerTest
[PageControllerTest GET /](https://github.com/arafatm/Book-Programming-Phoenix/commit/95ba2d2)

### Integration Tests

[TestHelpers insert_user  and insert_video](https://github.com/arafatm/Book-Programming-Phoenix/commit/dd350a7)

[VideoControllerTest requires user authentication on all actions](https://github.com/arafatm/Book-Programming-Phoenix/commit/cec2f22)

[AuthController allow easier authentication](https://github.com/arafatm/Book-Programming-Phoenix/commit/1c22b51)

[VideoControllerTest passing tests](https://github.com/arafatm/Book-Programming-Phoenix/commit/e381f38)

Using tags to separate tests requiring login
[VideoControllerTest tag login_as](https://github.com/arafatm/Book-Programming-Phoenix/commit/07a7f52)

We can now run tests by specific tag
`$ mix test test/controllers --only login_as`

[VideoControllerTest video creation](https://github.com/arafatm/Book-Programming-Phoenix/commit/a4141fe)

[VideoControllerTest authorize actions against access by other users](https://github.com/arafatm/Book-Programming-Phoenix/commit/3ed940a)

[Remove deprecation warnings](https://github.com/arafatm/Book-Programming-Phoenix/commit/c20fabd)

### Unit-Testing Plugs

Test `Rumbl.Auth`

[Rumbl.AuthTest initial authentication tests](https://github.com/arafatm/Book-Programming-Phoenix/commit/fc7c7bd)

First error: `Auth.authenticate_user` expects a `:current_user` 

```
test authenticate_user halts when no current_user exists (Rumbl.AuthTest)
  test/controllers/auth_test.exs:5
  ** (KeyError) key :current_user not found in: %{}
```

[Rumbl.AuthTest authenticate_user expects :current_user](https://github.com/arafatm/Book-Programming-Phoenix/commit/a7bf642)

next error

```
test authenticate_user halts when no current_user exists (Rumbl.AuthTest)
    test/controllers/auth_test.exs:5
    ** (ArgumentError) flash not fetched, call fetch_flash/2
```

### Testing Views and Templates
### Splitting Side Effects in Model Tests
### Wrapping Up

**TODO: Fix deprecation warnings**

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
