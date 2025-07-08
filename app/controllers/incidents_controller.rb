# app/controllers/incidents_controller.rb
class IncidentsController < ApplicationController
    before_action :set_incident, only: [:show, :start_replay]
    
    def index
      @incidents = Incident.all.order(created_at: :desc)
    end
    
    def show
      @suggestions = @incident.suggestions.recent.limit(50)
      @recent_messages = @incident.transcript_messages.ordered.limit(10)
    end
    
    def start_replay
      if @incident.active?
        # We'll build this service next
        IncidentReplayJob.perform_later(@incident)
        redirect_to @incident, notice: 'Replay started!'
      else
        redirect_to @incident, alert: 'Incident already processed'
      end
    end
    
    private
    
    def set_incident
      @incident = Incident.find(params[:id])
    end
  end