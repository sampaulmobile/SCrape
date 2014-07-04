SCrape::Application.routes.draw do

  mount Sidekiq::Web, at: "/sidekiq"
  mount Resque::Server, :at => "/resque"

  root 'static_pages#welcome'

  get '/scconnect', to: 'soundcloud#connect'
  get '/scconnected', to: 'soundcloud#connected'

  get '/dbconnect', to: 'dropbox#connect'
  get '/dbconnected', to: 'dropbox#connected'

  get '/reset', to: 'static_pages#reset'
  get '/connect', to: 'static_pages#connect'
  get '/finished', to: 'static_pages#finished'
  get '/sync', to: 'users#sync'

  get '/likes', to: 'users#likes'

end
