module Pakyow
  # App-specific helper methods.
  #
  module Helpers
	def current_user
	  return User[session[:user].to_i] if session && session[:user]
	  nil
	end

	def logged_in?
	  !current_user.nil?
	end

	def auth!(user, remember = false)
	  session[:user] = user.id
	  return unless remember

      # expire after 7 days
	  res.set_cookie(:user, path: "/", expires: Time.now + 60 * 60 * 24 * 7, value: user.id)
	end

	def unauth!
	  res.delete_cookie(:user)
	  session[:return_to] = nil
	  session[:user] = nil
	end
  end
end

