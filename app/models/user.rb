# frozen_string_literal: true

class User < ApplicationRecord
  # Virtual attributes of the model
  attr_accessor :remember_token, :activation_token, :reset_token

  before_save :downcase_email
  before_create :create_activation_digest

  validates :name, presence: true, length: { maximum: 50 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true

  # Note that has_secure_password ensures non-nil password (on create)
  has_secure_password
  # Note allow_nil: true permits empty passwords (don't update) on user#update
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  # Returns the hash digest (e.g. password_digest) of the given string
  # This should match...
  # https://github.com/rails/rails/blob/main/activemodel/lib/active_model/secure_password.rb
  def self.digest(string)
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create(string, cost:)
  end

  # Returns a random token
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  # Remembers a user in the database for use in persistent sessions
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
    remember_digest
  end

  # Returns a session token to prevent session hijacking
  # We reuse the remember digest for convenience
  def session_token
    remember_digest || remember
  end

  # Returns true if the given token matches the attribute digest
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Forget a user
  def forget
    update_attribute(:remember_digest, nil)
  end

  # Activates an account
  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest, User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  def send_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  private

  # Converts email to all lowercase
  def downcase_email
    email.downcase!
  end

  # Creates and addigns the activation token and digest
  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
