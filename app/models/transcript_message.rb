class TranscriptMessage < ApplicationRecord
  # Rails automatically knows about incident relationship
  belongs_to :incident
  
  validates :speaker, :content, :sequence_number, presence: true
  
  # Scopes (Rails way to create reusable queries)
  scope :ordered, -> { order(:sequence_number) }
  scope :recent, -> { order(created_at: :desc) }
end
