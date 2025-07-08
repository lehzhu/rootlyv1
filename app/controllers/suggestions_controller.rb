class SuggestionsController < ApplicationController
  def update
    @suggestion = Suggestion.find(params[:id])
    @suggestion.update!(status: params[:suggestion][:status])
    head :ok
  end
end
