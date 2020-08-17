class User < ApplicationRecord
  PERMIT_ATTRIBUTES = %i(name email password password_confirmation).freeze

  validates :name, presence: true,
            length: {maximum: Settings.regex.name_max_length}

  validates :email, presence: true,
    length: {maximum: Settings.regex.email_max_length},
    format: {with: URI::MailTo::EMAIL_REGEXP},
    uniqueness: true

  validates :password, presence: true,
            length: {minimum: Settings.regex.password_min_length}
  has_secure_password

  before_save :downcase_email

  def downcase_email
    email.downcase!
  end

  class << self
    def digest string
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end
  end
end
