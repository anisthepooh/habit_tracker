class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  belongs_to :group, optional: true
  has_one_attached :avatar

  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
