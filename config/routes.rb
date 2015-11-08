TabloConnect::Engine.routes.draw do
  root to: "home#index"

  get 'sync', to: 'sync#index'
  get 'movies', to: 'movies#index'
  get 'shows', to: 'shows#index'
  get 'episodes/:show', to: 'shows#episodes'
  get 'copy/:tablo_id/:type', to: 'copy#index'
  get 'copy/:tablo_id/:type/status', to: 'copy#status'
end
