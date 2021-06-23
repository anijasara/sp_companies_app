Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :companies do
    collection do
    #   get 'get_employees'
      get 'companies_with_less_required_employees'
      post 'remove_employees'
    end
    member do
      patch 'set_required_amount_of_employees'
    end
  end

  resources :employees
end
