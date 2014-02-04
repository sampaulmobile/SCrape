SCrape::Application.routes.draw do

  mount Sidekiq::Web, at: "/sidekiq"

  root 'static_pages#welcome'

  get '/connect', to: 'soundcloud#connect'
  get '/connected', to: 'soundcloud#connected'

  get '/finished', to: 'static_pages#finished'
  get '/sync', to: 'users#sync'

  get '/likes', to: 'users#likes'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

end
