require_relative "mailer_helpers"

# Background worker for sending a password reset link to a user.
#
class PasswordResetWorker
  include Sidekiq::Worker
  include WorkerMailerHelpers

  def perform(user_id)
    user = User[user_id]
    fail ArgumentError, "User[#{user_id}] could not be found" if user.nil?

    token = user.password_reset_token
    fail ArgumentError, "Token could not be found" if token.nil?

    mailer = mailer("mail/reset_password")
    mailer.view.scope(:token).bind(token)
    mailer.deliver_to(user.email)
  rescue ArgumentError => e
    logger.debug e.message
  end
end
