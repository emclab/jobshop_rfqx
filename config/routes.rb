JobshopRfqx::Engine.routes.draw do
  resources :rfqs do
    collection do
      get :search
      put :search_results
      get :stats
      put :stats_results
      get :copy_last
    end
  end

  root :to => 'rfqs#index'
end
