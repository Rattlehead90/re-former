class User < ApplicationRecord
  before_save { email.downcase! }
  validates :username, presence: true, uniqueness: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, uniqueness: true, length: { maximum: 255 },
            format: VALID_EMAIL_REGEX
  VALID_PASSWORD_REGEX = /\d/
  validates :password, presence: true, length: { minimum: 6 },
            format: VALID_PASSWORD_REGEX
end
