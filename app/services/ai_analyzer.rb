class AiAnalyzer
  def initialize
    @client = GoogleGenerativeAI::Client.new(
      api_key: Rails.application.credentials.google_api_key
    )
  end
  
  def analyze_context(messages)
    return [] if messages.empty?
    
    prompt = build_prompt(messages)
    
    response = @client.generate_content(
      model: 'gemini-1.5-flash',
      contents: prompt,
      generation_config: {
        response_mime_type: 'application/json',
        temperature: 0.1
      }
    )
    
    parse_response(response.text)
  rescue => e
    Rails.logger.error "AI Analysis failed: #{e.message}"
    []
  end
  
  private
  
  def build_prompt(messages)
    context = messages.map { |m| "#{m.speaker}: #{m.content}" }.join("\n")
    
    <<~PROMPT
      Analyze this incident conversation and extract actionable items.
      
      Conversation:
      #{context}
      
      Categories:
      - action_item: Tasks to do later  
      - timeline_event: Important status changes
      - root_cause: Theories about the cause
      - missing_info: Info that should be documented
      
      Return JSON array:
      [{"category": "action_item", "title": "Brief title", "description": "Why important"}]
      
      Only clear, actionable items. Empty array if nothing.
    PROMPT
  end
  
  def parse_response(text)
    JSON.parse(text).filter_map do |item|
      next unless valid_suggestion?(item)
      item
    end
  rescue JSON::ParserError
    []
  end
  
  def valid_suggestion?(item)
    item.is_a?(Hash) && 
    item['category'].present? && 
    item['title'].present? && 
    item['description'].present?
  end
end
