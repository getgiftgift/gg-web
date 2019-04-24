WorthdayWeb::Application.routes.draw do
  default_url_options :host => "www.getgiftgift.com"

  root :to => 'birthday_deals#index'
  
	# get '/party/:id' => 'birthday_parties#show'
  # get '/party => 'birthday_parties#index', as: 'party'
  match '/verify' => 'home#verify', via: [:get, :post]
  patch '/change_location' => 'users#change_location'
  get '/terms' => 'home#terms'
  get '/privacy' => 'home#privacy'
  get '/help' => 'home#help'
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks", registrations: "users/registrations" } do
  end
  devise_scope :user do
    get   '/my_account', to: 'users/registrations#show'
    patch '/users/update_birthday', to: 'users/registrations#update_birthday'
    patch '/users/update_location', to: 'users/registrations#update_location'
    get '/users/subscribe', to: 'users/registrations#subscribe'
    get '/users/unsubscribe', to: 'users/registrations#unsubscribe'
  end


  resources :subscriptions do
    member do
      patch :subscribe
      patch :unsubscribe
    end
  end
  get '/my_gifts' => "birthday_deals#my_gifts", as: 'my_gifts'

  resources :transactions, only: [:new, :create, :show]
  resources :companies, only: [:new, :create]

  resources :birthday_deals, only: [:index]
  resources :birthday_deal_vouchers, only: [:show, :index], path: 'birthday_deals' do
    member do
      put :trash
      put :keep
      get :print
      put :redeem
      get 'checkout' => 'transactions#new'
      get 'new_payment_method' => 'transactions#new_payment_method'
    end
  end

  resources :birthday_parties, only: [:show, :index], path: 'party' do
    post :donate, on: :member, to: 'transactions#create'
  end

  namespace :dashboard do
    get '/' => 'locations#index', as: 'index'
    resources :users
    resources :companies do
      resources :contacts
      resources :company_locations
      member do
        get :archive
        get :unarchive
      end
      collection do
        get :archived
        match :search, via: [:get, :post]
      end

    end

    resources :birthday_deal_vouchers, only: [:index], as: "deal_vouchers", path: 'birthday_deals' do
      member do
        put :trash
        put :keep
        get :print
      end
    end

    resources :locations do
      resources :birthday_deal_vouchers, only: [:index], as: 'voucher_reports', path: 'voucher_reports'
      resources :birthday_deals, shallow: true do
        member do
          put :submit_for_approval
          put :withdraw
          put :reject
          put :approve
        end
      end
    end

    resources :sponsorships do
      post :sponsor, on: :member
    end

  end

  # Catch all route to root path
  match '*path', to: redirect('/'), via: :all
end