Pakyow::App.routes :main do
  include SharedRoutes

  default after: [:prepare_nav] do
	# noop
  end
end
