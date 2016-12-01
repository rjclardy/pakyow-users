class Token < Sequel::Model
  plugin :validation_helpers

  many_to_one :user

  TYPE_PASSWORD = "password" unless defined? TYPE_PASSWORD
  VALID_TYPES = [TYPE_PASSWORD] unless defined? VALID_TYPES

  def validate
    super

    validates_presence [:user_id]
    errors.add(:type, "is invalid") unless Token::VALID_TYPES.include?(type)
  end

  def before_create
    self.code ||= SecureRandom.hex(10)
    self.expires_at ||= DateTime.now + 31

    super
  end

  def after_create
    # after creating invalidate any other tokens of this type that belong to this user
    invalidate_users_tokens!
    super
  end

  def self.find_valid(code)
    where("expires_at >= ?", DateTime.now).first(code: code, valid: true, used_at: nil)
  end

  def use!
    update_all(valid: false, used_at: DateTime.now)
  end

  def invalidate!
    update_all(valid: false)
  end

  private

  def invalidate_users_tokens!
    Token.where(user: user, type: type, valid: true).exclude(id: id).update(valid: false)
  end
end
