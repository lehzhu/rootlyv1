class Suggestion < ApplicationRecord
  belongs_to :incident
  enum status: { pending: 0, accepted: 1, dismissed: 2 }
  scope :recent, -> { order(created_at: :desc) }
end
