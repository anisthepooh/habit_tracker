class Entry < ApplicationRecord
  include PublicActivity::Model
  tracked only: [ :create ]
  belongs_to :habit
end
