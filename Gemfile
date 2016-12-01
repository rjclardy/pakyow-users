ruby "2.2.4"

Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

source "https://rubygems.org"

gem "pakyow", "~> 0.11.3", require: false
gem "pakyow-rake-db", git: "git://github.com/bryanp/pakyow-rake-db.git", require: false
gem "pakyow-assets", github: "pakyow/assets"

gem "puma"
gem "rake"
gem "pakyow-slim", "~> 1.0"
gem "sequel"
gem "pg"
gem "sidekiq"
gem "tzinfo"
gem "bcrypt"

# use dotenv to load environment variables
gem "dotenv", groups: [:development, :test, :prototype]

group :test do
  gem "rspec"
end

group :production do
  gem "dotenv-deployment"
end
