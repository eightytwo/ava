Ava::Application.routes.draw do

  # While in organisation only mode ensure registrations cannot be made by
  # overriding the user registration post method.
  match '/users' => 'home#index', :via => :post, :as => :user_registration

  # Devise and devise invitable routes.
  devise_for :users, :skip => [:sessions, :invitations]
  as :user do
    get 'login' => 'devise/sessions#new', :as => :new_user_session
    post 'login' => 'devise/sessions#create', :as => :user_session
    delete 'logout' => 'devise/sessions#destroy', :as => :destroy_user_session

    get 'users/invitation/new' => 'invitations#new', :as => :new_user_invitation
    get 'users/invitation/accept' => 'invitations#edit', :as => :accept_user_invitation
    post 'users/invitation/accept' => 'invitations#create', :as => :user_invitation
    put 'users/invitation/accept' => 'invitations#update'
  end

  # Organisation, folio and round routes.
  resources :organisations, :only => [:index, :show, :edit, :update]
  resources :folios, :except => [:index]
  resources :rounds, :except => [:index]

  get "home/index"

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'home#index'
end
