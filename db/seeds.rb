require 'json'

Suggestion.destroy_all
TranscriptMessage.destroy_all  
Incident.destroy_all

# Create transcript file path
transcript_file = Rails.root.join('transcript.json')

unless File.exist?(transcript_file)
  puts "Copy your transcript file to: #{transcript_file}"
  exit
end

data = JSON.parse(File.read(transcript_file))

incident = Incident.create!(
  title: "Database Saturation Incident",
  description: "Web tier experiencing high error rates",
  status: :active
)

data['meeting_transcript'].each_with_index do |msg, index|
  TranscriptMessage.create!(
    incident: incident,
    speaker: msg['speaker'],
    content: msg['text'],
    sequence_number: index
  )
end

puts "✅ Created incident: http://localhost:3000/incidents/#{incident.id}"
