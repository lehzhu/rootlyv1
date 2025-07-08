class ReplayJob < ApplicationJob
  def perform(incident_id)
    @incident = Incident.find(incident_id)
    @ai = AiAnalyzer.new
    
    process_messages_streaming
    @incident.resolved!
  end
  
  private
  
  def process_messages_streaming
    @incident.transcript_messages.ordered.each_with_index do |message, index|
      # Context: only messages up to current point
      context = @incident.transcript_messages
                         .where('sequence_number <= ?', index)
                         .ordered
                         .last(5)
      
      # Skip first few messages (need context)
      next if context.count < 3
      
      # Get AI suggestions
      suggestions = @ai.analyze_context(context)
      
      # Create suggestions
      suggestions.each do |suggestion_data|
        create_suggestion(suggestion_data)
      end
      
      # Wait 3 seconds (simulate real-time)
      sleep(3)
    end
  end
  
  def create_suggestion(data)
    @incident.suggestions.create!(
      category: data['category'],
      title: data['title'],
      description: data['description'],
      status: :pending
    )
  end
end
