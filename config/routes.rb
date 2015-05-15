Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'site#index'




#USERS

  patch '/addevent/:id' => 'users#addevent', as: "addevent"
  delete '/deleteevent/:id' => 'users#deleteevent', as: "deleteevent"
  resources :users do
#CALENDAR
    resources :calendars, only: [:index,:show] do
      get '/all_events' => 'calendars#all_events', on: :collection
      get '/:id/get_events' => 'calendars#get_events', on: :collection
      get '/:id/get_friend_events' => 'calendars#get_friend_events', on: :collection
      get '/:id/compare/get_events' => 'calendars#compare_events', on: :collection
    end
#COMPARING CALENDARS
    get '/calendars/:id/compare/:compare_id' => 'calendars#compare', as: 'compare_calendars'
#Messaging
    resources :comments, except: [:edit, :update, :index, :show] do
      resources :comments, except: [:edit, :update, :index, :show]
    end
  end


  resources :events do
    collection { post :import }
    resources :comments, except: [:edit, :update, :index, :show] do
      resources :comments, except: [:edit, :update, :index, :show]
    end
  end
  resources :tags, :only => [:new, :create, :index]

#BASIC AUTH
  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'

#OAUTH

get '/auth/failure' => 'auth#failure'
get '/auth/:provider/callback' => 'auth#callback'

#FESTIVAL ROUTE

get '/festivals' => 'festivals#index'
get '/festivals/myfestivals' => 'festivals#myfestivals'
get '/festivals/:id' => 'festivals#show', as: 'festival'
get '/festivals/view/:id' => 'festivals#view', as: 'view_festival'

# FRIEND RELATIONS ROUTES
get '/friends' => 'friends#index'
get '/friends/list' => 'friends#list'
post '/friends/invite' => 'friends#invite'
patch '/friends/invite/:id' => 'friends#accept', as: 'friend_invite'
delete '/friends/invite/:id' => 'friends#decline'
delete '/friends/delete/:id' => 'friends#destroy', as: 'friend_remove'

# MESSAGING
get '/inbox' => 'comments#index'
get '/inbox/message/:id' => 'comments#show', as: 'message'
get '/message/new' => 'comments#new', as: 'new_message'




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
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
