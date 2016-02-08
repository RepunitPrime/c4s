Rails.application.routes.draw do

  mount RedactorRails::Engine => '/redactor_rails'
  #Add routing to the profile page
  get 'profile/index'
  get 'profile/edit'
  patch 'profile/update'
  put 'profile/update'
  get 'profile/change_password'
  patch 'profile/update_password'
  put 'profile/update_password'

  post 'comments/delete'

  resources :profile

  resources :articles do
    resources :comments
  end

  resources :offers do
    resources :offer_comments
  end

  get 'welcome/index'
  get 'welcome/about_us'
  root 'welcome#index'

  #Add routing to the sign up page
  get 'signup' => 'signup#index'
  post 'signup' => 'signup#create'

  get 'articles/new' => 'articles#index'
  post 'articles/new' => 'articles#create'

  get 'articles/:id/chooseComment/:commentId' => 'articles#AddBestComment'

  get 'login' => 'sessions#index'
  post 'login' => 'sessions#login'
  delete 'logout' => 'sessions#logout'

  get ':controller(/:action)'
  get ':controller(/:action(/:id))(.:format)'

  get 'password_resets/index'
  get 'password_resets/new'
  get 'password_resets/index'
  post 'password_resets/index'
  get 'password_resets/create'
  post 'password_resets/create'
  post 'password_resets/edit'
  get 'password_resets/update'
  post 'password_resets/update'

  get 'account_activations/show'
  post 'account_activations/show'

  resources :account_activations, only: [:index]


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
#
#     collection do
#       get 'sold'
#     end
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
#   resources :postss, concerns: :toggleable
#   resources :photos, concerns: :toggleable

# Example resource route within a namespace:
#   namespace :admin do
#     # Directs /admin/products/* to Admin::ProductsController
#     # (app/controllers/admin/products_controller.rb)
#     resources :products
#   end
end
