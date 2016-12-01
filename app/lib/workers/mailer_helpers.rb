# Provides helper methods for creating mailers within
# Sidekiq workers.
#
module WorkerMailerHelpers
  private

  def mailer(path)
    Pakyow::Mailer.from_store(path, store)
  end

  def store
    Pakyow.app.presenter.store(:default)
  end
end

