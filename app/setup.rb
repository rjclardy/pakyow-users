require "bundler/setup"
require "pakyow"
require "pakyow-assets"

Pakyow::App.define do
  configure do
    ENV["TZ"] = "utc"

    Bundler.require :default, Pakyow::Config.env

    if defined?(Dotenv)
      env_path = ".env.#{Pakyow::Config.env}"
      Dotenv.load env_path if File.exist?(env_path)
      Dotenv.load
    end

    # setup sequel plugins + extensions
    Sequel::Model.plugin :validation_helpers
    Sequel::Model.plugin :timestamps, update_on_create: true
    Sequel::Plugins::ValidationHelpers::DEFAULT_OPTIONS.merge!(
      presence: { message: "must not be blank" }
    )

    app.db = Sequel.connect(ENV["DATABASE_URL"])
    app.uri = ENV["APP_URI"]
    app.name = "pakyow-users"
  end

  configure :development do
    require "pp"

    # best to use redis in development so UI works in jobs, etc.
    # also, ensures it works with multiple processes
    realtime.registry = Pakyow::Realtime::RedisRegistry
    ui.registry = Pakyow::UI::RedisMutationRegistry

    mailer.encoding = "UTF-8"
    mailer.delivery_method = :smtp
    mailer.delivery_options = { port: 1025 }
  end

  configure :production do
    # production config goes here
  end
end
