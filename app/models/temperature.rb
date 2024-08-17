class Temperature < ApplicationRecord
  validates :city, :value, :timestamp, presence: true
end
