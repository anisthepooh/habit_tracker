class Habit < ApplicationRecord
  has_many :entries, dependent: :destroy
end
