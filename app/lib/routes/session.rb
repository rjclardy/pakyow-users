Pakyow::App.routes :session do
  include SharedRoutes

  restful :session, "/session", after: [:prepare_nav] do
    new before: [:require_noauth] do
      redirect router.path(:default) if logged_in?

      view.scope(:session).with do |session_view|
        session_view.bind(@session_obj || {})
        session_view.scope(:error).mutate(:present, with: @errors) if @errors
      end
    end

    create before: [:require_noauth] do
      @session_obj = { login: params[:login], password: params[:password] }
      user = User.authenticate(@session_obj)

      if user
        auth!(user)
        return_to = request.session[:return_to]
        request.session[:return_to] = nil
        redirect return_to || router.path(:default)
      else
        @errors = ["Invalid login attempt"]
        reroute router.group(:session).path(:new), :get
      end
    end

    remove before: [:require_auth] do
      unauth!
      redirect "/login"
    end
  end

  ##
  # convenience routes
  get :login, "/login" do
    reroute router.group(:session).path(:new)
  end

  get :logout, "/logout" do
    reroute router.group(:session).path(:remove), :delete
  end
end

