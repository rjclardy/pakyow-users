Pakyow::App.routes :handlers do
  include SharedRoutes

  handler 401, after: [:prepare_nav] do
    presenter.path = "errors/401"
  end

  handler 403, after: [:prepare_nav] do
    presenter.path = "errors/403"
  end

  handler 404, after: [:prepare_nav] do
    presenter.path = "errors/404"
  end

  handler 500, after: [:prepare_nav] do
    presenter.path = "errors/500"
  end
end
