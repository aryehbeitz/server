Rails.application.routes.draw do

  scope '(:locale)', locale: /#{I18n.available_locales.join("|")}/  do
  scope '(:year)', year: /2019|2018|2017|2016|2015/  do
  resources :country_region_cities

  resources :staffs do

  end

  get '/new_staff' , :to => 'staffs#new_staff_page'
  post '/new_staff.json' , :to => 'staffs#new_staff'

  resources :witnesses do
    get :assign, on: :member
    get :unassign, on: :member
    resources :comments
    get '/witness_years', :to => 'witness_years#new_or_edit'
    get '/witness_years/:witness_year_id', :to => 'witness_years#new_or_edit'

    post '/witness_years', :to => 'witness_years#create_or_update'
    post '/witness_years/:witness_year_id', :to => 'witness_years#create_or_update'


  end

  resources :witness_salons
  resources :user_salons
  resources :salons

  devise_for :users, controllers: { registrations: "registrations" }
  resources :users

  get 'signup', :to => 'users#new', as: :signup
  get "pages/home", :to => 'pages#home', as: :host_search

  resources :salon do
    resources :comments
  end

  get "pages/salon_register_link", :to => 'pages#salon_register_link', as: :salon_register_link


  end
  end

  root 'pages#welcome'

end