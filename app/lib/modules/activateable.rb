# This is a mixin that provides helpers for interacting with models that can
# be in an active/inactive state. It assumes there is an `active` bool on the model.
#
module Activateable
  # GETTERS (class-level)

  def self.included(base)
    def base.active(args = {})
      args[:active] = true
      where(args)
    end

    def base.inactive(args = {})
      args[:active] = false
      where(args)
    end
  end

  # SETTERS

  def activate!
    self.active = true
    save(validate: false)
  end

  def deactivate!
    self.active = false
    save(validate: false)
  end

  def activate
    self.active = true
    save
  end

  def deactivate
    self.active = false
    save
  end

  def toggle_active!
    self.active = !self.active
    save(validate: false)
  end

  def toggle_active
    self.active = !self.active
    save
  end

  # CHECKERS

  def active?
    active == true
  end

  def inactive?
    !active?
  end
end
