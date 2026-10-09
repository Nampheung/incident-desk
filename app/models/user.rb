class User < ApplicationRecord
  ROLES = %w[ customer agent ].freeze

  rolify
  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :email_address, presence: true, uniqueness: { case_sensitive: false },
    format: { with: URI::MailTo::EMAIL_REGEXP }
  validate :must_have_exactly_one_role

  def role
    roles.first&.name
  end

  def role=(name)
    name = name.to_s
    self.roles = ROLES.include?(name) ? [ Role.find_or_create_by!(name: name) ] : []
  end

  def customer?
    role == "customer"
  end

  def agent?
    role == "agent"
  end

  private
    def must_have_exactly_one_role
      unless roles.size == 1 && ROLES.include?(roles.first.name)
        errors.add(:role, "must be one of: #{ROLES.join(", ")}")
      end
    end
end
