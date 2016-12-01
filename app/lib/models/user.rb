require_relative "../modules/activateable"

class User < Sequel::Model
  include Activateable

  plugin :validation_helpers

  one_to_many :tokens

  attr_accessor :password, :password_confirmation, :ignore_password

  @login_fields = [:email]

  def validate
	super

	validates_presence [:email]
	validates_unique :email
	validates_format /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i, :email
	validates_presence :password unless ignore_password
	if password
	  validates_min_length 4, :password, message: "must have at least 4 characters"
	  errors.add(:password, "must match confirmation") if password && password != password_confirmation
	end
  end

  def password_reset_token
    tokens_dataset.first(type: Token::TYPE_PASSWORD, valid: true)
  end

  def password=(pw)
	return if pw.nil? || pw.empty?
	@password = pw

	self.crypted_password = BCrypt::Password.create(pw)
  end

  # Authenticates a user by their login name and unencrypted password.
  # Returns the user or nil.
  def self.authenticate(session)
	user = nil

	@login_fields.find do |login_field|
	  user = first(login_field => session[:login], active: true)
	end

	return if user.nil?
	return user if session[:password] && user.authenticated?(session[:password])
  end

  def authenticated?(password)
	BCrypt::Password.new(crypted_password) == password
  end
end
