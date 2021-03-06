Rails.application.routes.draw do
  get 'welcome/index'
  get 'welcome/splash'
  get 'welcome/auth'
  get 'welcome/oauth2callback'
  get 'welcome/create_username'
  get 'welcome/logout'
  get 'alldecks/index'
  get 'alldecks/live_search_decks'

  resources :users do
    collection do
      get 'live_search_users'
    end
    resources :decks do
      member do
        post 'validate'
        get 'take_quiz'
        get 'start_quiz'
        post 'copy_deck'
        get 'end_quiz'
      end
      resources :cards
    end
  end

  root 'welcome#index'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  # /products/1/short
  #     collection do
  #       get 'sold'
  #     end
  # /products/sold
  # /products/new
  # /decks/2/next_card
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
