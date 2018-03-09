Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :v1 do
    get "/products" => "products#index"
    get "/product/:id" => "products#show"
    get "/product" => "products#show"
  end
end
