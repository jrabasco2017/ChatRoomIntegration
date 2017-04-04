class User < ApplicationRecord
  has_many :chat_rooms, dependent: :destroy
  has_many :parties
  has_many :events, through: :parties
  has_many :messages, dependent: :destroy
  

  attr_accessor :remember_token

  before_save { self.email = email.downcase}
  validates :username, presence: true, length: { maximum: 50 },
                       uniqueness: {case_sensitive: false }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[brandeis]+\.[edu]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  #Returns a random User token
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  #Forgets a User
  def forget
    update_attribute(:remember_digest, nil)
  end

  def name
    email.split('@')[0]
  end

end