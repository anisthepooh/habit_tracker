class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  belongs_to :group, optional: true
  has_many :habits, through: :group
  has_many :entries, through: :habits
  has_one_attached :avatar
  has_one_attached :cropped_avatar

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  attr_accessor :remove_avatar

  before_save :purge_avatar_if_requested

  def purge_avatar_if_requested
    avatar.purge if ActiveModel::Type::Boolean.new.cast(remove_avatar)
  end
end
