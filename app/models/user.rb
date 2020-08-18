class User < ApplicationRecord
  PERMIT_ATTRIBUTES = %i(name email password password_confirmation).freeze

  attr_accessor :remember_token

  validates :name, presence: true,
            length: {maximum: Settings.regex.name_max_length}

  validates :email, presence: true,
    length: {maximum: Settings.regex.email_max_length},
    format: {with: URI::MailTo::EMAIL_REGEXP},
    uniqueness: true

  validates :password, presence: true,
            length: {minimum: Settings.regex.password_min_length},
            allow_nil: true
  has_secure_password

  before_save :downcase_email

  def downcase_email
    email.downcase!
  end

  class << self
    def digest string
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_attribute :remember_digest, User.digest(remember_token)
  end

  def authenticated? remember_token
    return false unless remember_digest

    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  def forget
    update_attribute :remember_digest, nil
  end
end
