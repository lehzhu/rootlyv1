# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  # Rails security feature
  protect_from_forgery with: :exception
end