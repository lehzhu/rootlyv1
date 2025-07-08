class Incident < ApplicationRecord
  has_many :transcript_messages, dependent: :destroy
  has_many :suggestions, dependent: :destroy
  
  enum status: { active: 0, resolved: 1 }
  
  validates :title, presence: true
end
