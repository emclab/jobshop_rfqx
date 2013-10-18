Rails.application.routes.draw do

  get "user_menus/index"

  mount JobshopRfqx::Engine => "/jobshop_rfqx"
  mount Authentify::Engine => "/authentify"
  mount Commonx::Engine => "/commonx"
  mount EventTaskx::Engine => '/event_taskx'
  mount JobshopQuotex::Engine => '/jobshop_quotex'
  mount Kustomerx::Engine => '/kustomerx'
  mount MfgProcessx::Engine => '/mfg_processx'
  
  resource :session
  
  root :to => "authentify::sessions#new"
  match '/signin',  :to => 'authentify::sessions#new'
  match '/signout', :to => 'authentify::sessions#destroy'
  match '/user_menus', :to => 'user_menus#index'
  match '/view_handler', :to => 'authentify::application#view_handler'
end
