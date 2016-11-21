Rails.application.routes.draw do
  #get 'game', to: 'play#game'
  get 'game', to: 'play#game'
  #when we use 'post' we hide the content on the html body
  post 'score', to: 'play#score'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
