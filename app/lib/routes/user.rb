Pakyow::App.routes :password do
  include SharedRoutes

  restful :user, "/users" do
    collection after: [:prepare_nav] do
      get :forgot_password, "/forgot-password", before: [:require_noauth] do
        presenter.path = "users/forgot_password"
        view.scope(:user).with do |user_view|
          user_view.bind(@user || User.new)
          user_view.scope(:error).mutate(:present, with: @errors || [])
        end
      end

      post :forgot_password, "/forgot-password", before: [:require_noauth] do
        user = User.where(email: params[:email]).first

        if user
          Token.create(user: user, type: Token::TYPE_PASSWORD)
          PasswordResetWorker.perform_async(user.id)
          redirect router.group(:user).path(:reset_link_sent, user_id: user.id)
        else
          @user = User.new(email: params[:email])
          @errors = ["No user found"]
          reroute router.group(:user).path(:forgot_password), :get
        end
      end

      get :reset_link_sent, "/:user_id/reset-link-sent", before: [:require_noauth] do
        handle(404) unless user = User[params[:user_id].to_i]
        presenter.path = "users/reset_link_sent"
        view.scope(:user).bind(user)
      end

      get :provide_password, "set-password/:token", before: [:require_noauth] do
        presenter.path = "users/set_password"
        token = Token.find_valid(params[:token])

        if token
          view.scope(:user).with do |user_view|
            user_view.bind(token: token.code)
            user_view.scope(:error).mutate(:present, with: @errors || [])
          end
        else
          @errors = ["Invalid token"]
          reroute router.group(:user).path(:forgot_password)
        end
      end

      post :set_password, "set-password", before: [:require_noauth] do
        token = Token.find_valid(params[:token])

        if token
          user = token.user
          user.password = params[:password]
          user.password_confirmation = params[:password_confirmation]

          if user.valid?
            user.save
            token.use!

            redirect router.path(:login)
          else
            @errors = user.errors.full_messages.map(&:capitalize)
            reroute router.group(:user).path(:provide_password, token: token.code), :get
          end
        else
          @errors = ["Invalid Token"]
          reroute router.group(:user).path(:forgot_password), :get
        end
      end
    end
  end
end
