Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "/all-products" => "products#all_products"
  get "/shirt1-xs" => "products#shirt1_xs"
  get "/shirt1-sm" => "products#shirt1_sm"
  get "/shirt1-md" => "products#shirt1_md"
  get "/shirt1-lg" => "products#shirt1_lg"
  get "/shirt1-xl" => "products#shirt1_xl"
  get "/shirt2-sm" => "products#shirt2_sm"
  get "/shirt2-md" => "products#shirt2_md"
  get "/shirt2-lg" => "products#shirt2_lg"
end
