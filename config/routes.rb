Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :v1 do
    get "/all-products" => "products#all_products"
    get "/product/:id" => "products#product_by_id"
    get "/product" => "products#product_by_id"
  end
end
