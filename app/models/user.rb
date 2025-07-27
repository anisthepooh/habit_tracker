class User < ApplicationRecord
  include PublicActivity::Model
  tracked only: [ :create, :destroy ]

  ROLES= %w[admin user]

  has_secure_password

  validates :password, length: { minimum: 8 },
                      format: { with: /\A(?=.*[A-Z])(?=.*\d).*\z/,
                               message: "must contain at least one uppercase letter and one digit" },
                      if: -> { password.present? }

  has_many :sessions, dependent: :destroy
  has_many :habits, dependent: :destroy
  has_many :entries, through: :habits
  has_many :onboardings, dependent: :destroy
  has_one_attached :avatar
  has_one_attached :cropped_avatar
  has_one :user_configuration, dependent: :destroy
  has_many :notifications, as: :recipient, dependent: :destroy, class_name: "Noticed::Notification"
  accepts_nested_attributes_for :user_configuration

  scope :created_in_the_past_month, -> { where("created_at >= ?", 1.month.ago) }

   def self.ransackable_associations(auth_object = nil)
    %w[
      activities
      avatar_attachment
      avatar_blob
      cropped_avatar_attachment
      cropped_avatar_blob
      entries
      habits
      sessions
      user_configuration
    ]
  end

  # Optional: Also define ransackable_attributes
  def self.ransackable_attributes(auth_object = nil)
    %w[first_name last_name email_address created_at]
  end


  normalizes :email_address, with: ->(e) { e.strip.downcase }

  attr_accessor :remove_avatar

  before_save :purge_avatar_if_requested

  def purge_avatar_if_requested
    avatar.purge if ActiveModel::Type::Boolean.new.cast(remove_avatar)
  end

  def full_name
    "#{first_name} #{last_name}".strip
  end

  # Timezone helper methods
  def time_zone
    timezone.presence || "UTC"
  end

  def current_time
    Time.current.in_time_zone(time_zone)
  end

  # Low-res avatar for preloading (tiny, blurred)
  def avatar_placeholder
    return unless avatar.attached?
    begin
      avatar.variant(resize_to_limit: [ 32, 32 ], quality: 30)
    rescue => e
      Rails.logger.error "Avatar placeholder generation failed: #{e.message}"
      avatar # Fallback to original if variant fails
    end
  end

  # High-res avatar for main display
  def avatar_display
    return unless avatar.attached?
    begin
      avatar.variant(resize_to_limit: [ 128, 128 ], quality: 85)
    rescue => e
      Rails.logger.error "Avatar display generation failed: #{e.message}"
      avatar # Fallback to original if variant fails
    end
  end

  def has_seen_onboarding?(guide_name)
    onboardings.for_guide(guide_name).viewed.exists?
  end

  def has_completed_onboarding?(guide_name)
    onboardings.for_guide(guide_name).completed.exists?
  end

  def mark_onboarding_viewed(guide_name)
    onboarding = onboardings.find_or_initialize_by(guide_name: guide_name)
    onboarding.mark_viewed! unless onboarding.viewed?
    onboarding
  end

  def mark_onboarding_completed(guide_name)
    onboarding = onboardings.find_or_initialize_by(guide_name: guide_name)
    onboarding.mark_viewed! unless onboarding.viewed?
    onboarding.mark_completed! unless onboarding.completed?
    onboarding
  end

  def onboarding_for(guide_name)
    onboardings.find_by(guide_name: guide_name)
  end
end
