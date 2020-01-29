Rails.application.routes.draw do
  resources :movies, param: :movie_id, only: [:index, :show]
end
