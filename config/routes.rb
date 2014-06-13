JobshopRfqx::Engine.routes.draw do
  resources :rfqs do
    collection do
      get :search
      get :search_results
      get :stats
      get :stats_results
      get :copy_last
    end
  end

  root :to => 'rfqs#index'
end
