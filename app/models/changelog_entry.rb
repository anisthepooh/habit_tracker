class ChangelogEntry < ApplicationRecord
  scope :published, -> { where(published: true) }
end
