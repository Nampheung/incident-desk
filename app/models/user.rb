class User < ApplicationRecord
  ROLES = %w[ customer agent ].freeze

  rolify
  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :email_address, presence: true, uniqueness: { case_sensitive: false },
    format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :role, inclusion: { in: ROLES, message: "must be one of: #{ROLES.join(", ")}" }

  after_save :save_role, if: -> { @role }

  def role
    @role || roles.first&.name
  end

  def role=(name)
    @role = name.to_s
  end

  def reload(*)
    @role = nil
    super
  end

  def customer?
    role == "customer"
  end

  def agent?
    role == "agent"
  end

  private
    def save_role
      self.roles = [ Role.find_or_create_by!(name: @role) ]
      @role = nil
    end
end
