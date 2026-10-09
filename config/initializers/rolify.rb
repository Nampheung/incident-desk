Rolify.configure do |config|
  # Every user has exactly one global role: "customer" or "agent" (see User::ROLES).
  # Keep role rows even when no user holds them.
  config.remove_role_if_empty = false
end
