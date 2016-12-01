require "sidekiq"

require_relative "../app/setup"
Pakyow::App.stage(ENV["APP_ENV"] || ENV["RACK_ENV"])

require_relative "../app/lib/workers/password_reset_worker"
