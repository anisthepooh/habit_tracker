class Onboarding < ApplicationRecord
  belongs_to :user
  
  validates :guide_name, presence: true, uniqueness: { scope: :user_id }
  
  scope :viewed, -> { where.not(viewed_at: nil) }
  scope :completed, -> { where.not(completed_at: nil) }
  scope :for_guide, ->(guide_name) { where(guide_name: guide_name) }
  
  def viewed?
    viewed_at.present?
  end
  
  def completed?
    completed_at.present?
  end
  
  def mark_viewed!
    update!(viewed_at: Time.current) unless viewed?
  end
  
  def mark_completed!
    update!(completed_at: Time.current) unless completed?
  end
end
