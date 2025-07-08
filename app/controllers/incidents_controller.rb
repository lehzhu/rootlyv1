class IncidentsController < ApplicationController
  def index
    @incidents = Incident.all
  end
  
  def show
    @incident = Incident.find(params[:id])
    @suggestions = @incident.suggestions.recent
    @messages = @incident.transcript_messages.ordered.limit(10)
  end
  
  def start_replay
    @incident = Incident.find(params[:id])
    ReplayJob.perform_later(@incident.id)
    redirect_to @incident, notice: 'Replay started!'
  end
end
