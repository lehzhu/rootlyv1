Rails.application.routes.draw do
  root 'incidents#index'
  resources :incidents do
    member { post :start_replay }
  end
  resources :suggestions, only: [:update]
end
