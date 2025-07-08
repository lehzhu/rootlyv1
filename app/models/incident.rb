class Incident < ApplicationRecord
  # Rails automatically creates these from the migration:
  # - title, status, description attributes
  # - created_at, updated_at timestamps
  
  # Relationships (Rails magic)
  has_many :transcript_messages, dependent: :destroy
  has_many :suggestions, dependent: :destroy
  
  # Enums (Rails feature for status fields)
  enum status: { active: 0, resolved: 1 }
  
  # Validations (Rails way to ensure data quality)
  validates :title, presence: true
  
  # Custom methods
  def total_messages
    transcript_messages.count
  end
  
  def processing_interval_ms
    return 0 if total_messages.zero?
    (60_000 / total_messages).to_i  # 60 seconds in milliseconds
  end
end
