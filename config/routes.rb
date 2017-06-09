AppList::Application.routes.draw do

  resources :people do
    member do
       get :delete
    end
  end
    
  resources :families do
    member do
       get :verify
       get :check
       get :reset
       get :upload
       get :delete
    end
    collection do
      get :parents
      get :check_all
      get :reset_all
      get :list
      get :photo
      get :print
      get :print_photo
      get :logout
    end
  end

  resources :contacts
  resources :categories
  
  resources :courses, path: :c do
    member do
      get 'crawl'
      get 'delete'
      get 'toc'
    end
  end
  
  resources :lessons, path: :l  do
    member do
      get 'delete'
      get 'up'
      get 'down'
      get 'first'
      get 'last'
    end
  end

  
  resources :authors, path: :a
  resources :formats
  resources :media

  resources :audits
  resources :properties

  resources :settings
  mount RailsSettingsUi::Engine, at: 'settings'
  resources :roles

  devise_for :users,   :controllers => { :registrations => "registrations"} do
    #get '/users/sign_out', to: 'devise/sessions#destroy', :as => :destroy_user_session
    #get '/users/logout' => 'devise/sessions#destroy'
  end


  resources :users 

  resources :pages

  get '/cc', to: 'families#new'

  get '/categories/:id', to: 'categories#show'
  get '/courses/:id', to: 'courses#show'
  get '/lessons/:id', to: 'lessons#show'
  get '/authors/:id', to: 'authors#show'

  get '/:id', to: 'search#show'

  root :to => 'pages#home'
  get ':action', :to => 'pages'

end 
