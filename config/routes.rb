Rails.application.routes.draw do
  post 'user_token' => 'user_token#create'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :v1 do
    get "/products" => "products#index"
    post "/products" => "products#create"
    get "/products/:id" => "products#show"
    patch "/products/:id" => "products#update"
    delete "/products/:id" => "products#destroy"

    get "/images" => "images#index"
    post "/images" => "images#create"
    get "/images/:id" => "images#show"
    patch "/images/:id" => "images#update"

    get "/users" => "users#index"
    post "/users" => "users#create"
    get "/users/:id" => "users#show"
    get "/current_user" => "users#current"

    get "/cartedproducts" => "carted_products#index"
    post "/cartedproducts" => "carted_products#create"
    delete "/cartedproducts/:id" => "carted_products#destroy"

    get "/orders" => "orders#index"
    post "/orders" => "orders#create"

    get "/categories" => "categories#index"
    get "/categories/:id" => "categories#show"
  end
end
