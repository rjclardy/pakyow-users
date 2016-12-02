This repo is a base Pakyow v0.11 project plus a set of migrations, models, views, and routes for basic user authentication.

# Getting Started

1. Clone this repo:

  ```
  git clone git@github.com:rjclardy/pakyow-users.git
  ```

2. Add this function to your `~/.bash_profile` to make creating new Pakyow User apps easy:

  ```bash
  pakyow-users() { cp -r /full/path/to/pakyow-users "$@"; cd "$@"; rm -rf .git; }
  ```

# Creating Projects

1. Create a new Pakyow Users project from the command line:

  ```
  pakyow-users myapp
  ```

2. Open each of the migration files and add/remove properties to match the needs of your app. (Note: This is an optional step. You can always come back and write new migrations to modify the default schema at any point.)

3. Setup the database:

  ```
  bundle exec rake db:setup
  ```

4. You've now got a Pakyow project bootstrapped with basic user authentication! Start the server and find your app running at [http://localhost:3000](http://localhost:3000):

  ```
  bundle exec pakyow server
  ```

5. Modify the default models, views, and routes as needed while building out the rest of your app.
