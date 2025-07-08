class TranscriptMessage < ApplicationRecord
  belongs_to :incident
  scope :ordered, -> { order(:sequence_number) }
end
