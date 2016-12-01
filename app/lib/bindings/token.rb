Pakyow::App.bindings :token do
  scope :token do
    binding :password_reset_href do
      part :href do
        File.join(Pakyow::Config.app.uri, router.group(:user).path(:provide_password, token: bindable.code))
      end
    end
  end
end
