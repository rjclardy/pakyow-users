# A route mixin for defining shared routes.
#
module SharedRoutes
  include Pakyow::Routes

  fn :require_auth do
    unless logged_in?
      session[:return_to] = request.env["PATH_INFO"]
      redirect router.path(:login)
    end
  end

  fn :require_noauth do
    redirect router.path(:default) if logged_in?
  end

  fn :prepare_nav do
    view.scope(:nav).with do
      prop(logged_in? ? :login : :logout).remove
    end
  end
end
