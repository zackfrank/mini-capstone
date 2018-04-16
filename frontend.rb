require "unirest"
require "tty-table"
require "tty-prompt"

@signin = false
@admin = false

# user options
def login
  # prompt = TTY::Prompt.new
  # print "Please enter your email: "
  # email = gets.chomp
  # password = prompt.mask "Please enter password: "

  response = Unirest.post(
    "http://localhost:3000/user_token",
    parameters: {
      auth: {
        # email: email,
        # password: password
        email: "zack@email.com",
        password: "password"
      }
    }
  )
  # Save the JSON web token from the response
  jwt = response.body["jwt"]
  if jwt != nil
    @signin = true
  end
  # Include the jwt in the headers of any future web requests
  Unirest.default_header("Authorization", "Bearer #{jwt}")
  # puts "Welcome! Your jwt is #{jwt}"
  # puts
  # print "[Enter] to Continue: "
  # gets.chomp
end

def signup 
  prompt = TTY::Prompt.new
  params = {}
  print "Enter first name: "
  params[:first_name] = gets.chomp
  print "Enter last name: "
  params[:last_name] = gets.chomp
  print "Enter email: "
  params[:email] = gets.chomp
  params[:password] = prompt.mask "Enter password: "
  params[:password_confirmation] = prompt.mask "Enter password again: "
  response = Unirest.post("http://localhost:3000/v1/users", parameters: params)
  body = response.body
  puts JSON.pretty_generate(body)
  puts
  print "[Enter] to Continue ('q' to Quit): "
  gets.chomp
end

def logout
  puts "You can login, but you can't logout"
  puts
  gets.chomp
  jwt = ''
  Unirest.clear_default_headers()
  @signin = false
  puts "Just kidding. You're now logged out."
  puts
  print "[Enter] to Continue: "
  gets.chomp
end

def get_user_name
  response = Unirest.get("http://localhost:3000/v1/current_user")
  body = response.body
  @name = body["first_name"]
  @admin = body["admin"]
end

# shopping options
def view_all
  print "Order by [1]id or [2]price?: "
  choice = gets.chomp
  if choice == "1"
    order_by = "id"
  elsif choice == "2"
    order_by = "price"
  end
  response = Unirest.get("http://localhost:3000/v1/products?order_by=#{order_by}")
  page = response.body
  page = page.map { |product|
    { 
      id: product["id"],
      name: product["name"],
      size: product["size"], 
      price: product["price"],
      is_discounted: product["is_discounted"],
      tax: product["tax"], 
      total: product["total"],
      description: product["description"],
      in_stock: product["in_stock"],
      images_description_front: product["images"][0]["description"],
      images_url_front: product["images"][0]["url"],
      images_description_back: product["images"][1]["description"],
      images_url_back: product["images"][1]["url"],
      supplier: product["supplier"]["name"],
      categories: product["categories"]
    }
  }
  puts JSON.pretty_generate(page)
  puts
  print "[Enter] to Continue: "
  gets.chomp
end

def view_one
  print "Enter a product id: "
  id = gets.chomp 
  if id == "" or id.to_i == 0
    print "Please enter valid id, [Enter] to return to main menu: "
    gets.chomp
    return
  end
  response = Unirest.get("http://localhost:3000/v1/products/#{id}")
  page = response.body
  if page == "null"
    print "Please enter valid id, [Enter] to return to main menu: "
    gets.chomp
    return
  end
  page =
    { 
      id: page["id"],
      name: page["name"],
      size: page["size"], 
      price: page["price"],
      is_discounted: page["is_discounted"],
      tax: page["tax"], 
      total: page["total"],
      description: page["description"],
      in_stock: page["in_stock"],
      images_description_front: page["images"][0]["description"],
      images_url_front: page["images"][0]["url"],
      images_description_back: page["images"][1]["description"],
      images_url_back: page["images"][1]["url"],
      supplier: page["supplier"]["name"],
      categories: page["categories"]
    }
  system "clear"
  puts JSON.pretty_generate(page)
  puts
  print "[Enter] to Continue: "
  gets.chomp
end

def search
  while true
    print "Enter Search Query: "
    search = gets.chomp
    response = Unirest.get("http://localhost:3000/v1/products?search=#{search}")
    page = response.body
    page = page.map { |product|
      { 
        id: product["id"],
        name: product["name"],
        size: product["size"], 
        price: product["price"],
        is_discounted: product["is_discounted"],
        tax: product["tax"], 
        total: product["total"],
        description: product["description"],
        in_stock: product["in_stock"],
        images_description_front: product["images"][0]["description"],
        images_url_front: product["images"][0]["url"],
        images_description_back: product["images"][1]["description"],
        images_url_back: product["images"][1]["url"],
        supplier: product["supplier"]["name"],
        categories: product["categories"]
      }
    }
    puts JSON.pretty_generate(page)
    puts
    print "[Enter] to Search again ([1] to Go to Main Menu): "
    if gets.chomp == '1'
      break
    end
  end
end

def view_table
  response = Unirest.get("http://localhost:3000/v1/products")
  page = response.body
  table = TTY::Table.new [
    'Name', 
    'Size', 
    'Price',
    'Description'
    ], 
      page.map {|product| 
        [
          product["name"], 
          product["size"], 
          product["price"], 
          product["description"]
        ]
      }
  # table = TTY::Table.new ['header1','header2'], [['a1', 'a2'], ['b1', 'b2']]
  puts table.render(:unicode)
  puts
  print "[Enter] to Continue: "
  gets.chomp
end

def view_products_in_category
  puts "Enter category to view products: "
  puts "[1] All Shirts"
  puts "[2] Crew-neck shirts"
  puts "[3] V-neck shirts"
  print "Entry: "
  entry = gets.chomp
  if entry == "" or entry.to_i > 3 or entry.to_i == 0
    print "Please enter valid entry, [Enter] to return to main menu: "
    gets.chomp
    return
  end
  response = Unirest.get("http://localhost:3000/v1/categories/#{entry}")
  body = response.body
  products = body["products"]
  puts JSON.pretty_generate(products)
  puts
  print "[Enter] to Continue: "
  gets.chomp
end

def add_items_to_cart
  params = {}
  print "Enter product id: "
  params[:id] = gets.chomp
  if params[:id] == "" or params[:id].to_i == 0
    print "Please enter a valid product id. [Enter] to return to main menu: "
    gets.chomp
    return  
  end
  print "Enter quantity: "
  params[:quantity] = gets.chomp
  if params[:quantity] == "" or params[:quantity].to_i == 0
    print "Please enter a valid product id. [Enter] to return to main menu: "
    gets.chomp
    return  
  end
  response = Unirest.post("http://localhost:3000/v1/cartedproducts", parameters: params)
  body = response.body
  puts "Here is what you added to your cart:"
  puts JSON.pretty_generate(body)
  puts
  print "[Enter] to continue: "
  gets.chomp
end

def view_items_in_cart
  response = Unirest.get("http://localhost:3000/v1/cartedproducts")
  @cart = response.body
  if @cart == []
    puts
    puts "** You have nothing in your cart **"
    puts
    print "[Enter] to return to main menu: "
    gets.chomp
    return
  end
  puts "Here are the items currently in your cart:"
  puts JSON.pretty_generate(@cart)
  puts
  print "[Enter] to continue: "
  gets.chomp
end

def remove_item_from_cart
  view_items_in_cart
  if @cart == []
    return
  end
  print "**CART ID** of items to remove from cart: "
  id = gets.chomp
  if id.include? "," or id.include? " "
    print "Only enter one cart id at a time."
    gets.chomp
    return
  elsif id.to_i == 0
    print "Not a valid cart id. [Enter] to return to main menu: "
    gets.chomp
    return
  end
  response = Unirest.delete("http://localhost:3000/v1/cartedproducts/#{id}")
  body = response.body
  puts JSON.pretty_generate(body)
  print "[Enter] to continue: "
  gets.chomp
end

def order
  params = {}
  view_items_in_cart
  if @cart == []
    return
  end
  print "Are you sure you want to convert your cart to an order? [Y/N]: "
  confirmation = gets.chomp
  if confirmation == "Y" or confirmation == "y"
  else
    return
  end
  response = Unirest.post("http://localhost:3000/v1/orders")
  body = response.body
  puts JSON.pretty_generate(body)
  puts
  print "[Enter] to continue"
  gets.chomp
end

def see_orders
  response = Unirest.get("http://localhost:3000/v1/orders")
  body = response.body
  puts JSON.pretty_generate(body)
  print "[Enter] to continue: "
  gets.chomp
end

# admin options
def create_product
  params = {}
  print "Name: "
  params[:name] = gets.chomp
  print "Size: "
  params[:size] = gets.chomp
  print "Price: "
  params[:price] = gets.chomp
  print "Description: "
  params[:description] = gets.chomp
  print "In Stock: "
  params[:in_stock] = gets.chomp
  print "Supplier id: "
  params[:supplier_id] = gets.chomp
  response = Unirest.post("http://localhost:3000/v1/products", parameters: params)
  page = response.body
  if page["errors"] != nil
    puts
    puts "*****"
    puts "There was an issue:"
    puts "*****"
    puts page["errors"]
  else
    puts JSON.pretty_generate(page)
  end
  puts
  print "[Any Key] to Continue: "
  gets.chomp
end

def update_product
  print "Product id: "
  id = gets.chomp
  if id == ""
    print "Please enter valid id, [Enter] to continue: "
    gets.chomp
    return
  end
  params = {}
  current_page = Unirest.get("http://localhost:3000/v1/products/#{id}").body
  puts "Name: #{current_page["name"]}"
  print "(Enter to skip) Change name to: "
  params[:name] = gets.chomp
  puts "Size: #{current_page["size"]}"
  print "(Enter to skip) Change size to: "
  params[:size] = gets.chomp
  puts "Price: " + current_page["price"].to_s
  print "(Enter to skip) Change price to: "
  params[:price] = gets.chomp
  puts "Description: #{current_page["description"]}"
  print "(Enter to skip) Change description to: "
  params[:description] = gets.chomp
  puts "In Stock: #{current_page["in_stock"]}"
  print "(Enter to skip) Change in stock to: "
  params[:in_stock] = gets.chomp
  puts "Supplier: #{current_page["supplier"]["name"]}"
  print "(Enter to skip) Change supplier [1]ZFRANK [2]MFrank: "
  params[:supplier_id] = gets.chomp
  params.delete_if { |_key, value| value.empty? }
  response = Unirest.patch("http://localhost:3000/v1/products/#{id}", parameters: params)
  page = response.body
  if page["errors"] != nil
    puts
    puts "*****"
    puts "There was an issue:"
    puts "*****"
    puts page["errors"]
  else
    puts JSON.pretty_generate(page)
  end
  puts
  print "[Enter] to Continue: "
  gets.chomp
end

def update_image
  params = {}
  print "Image id: "
  id = gets.chomp
  if id == ""
    print "Please enter valid id, [Enter] to continue: "
    gets.chomp
    return
  end
  body = Unirest.get("http://localhost:3000/v1/images/#{id}").body
  puts "Title: #{body["title"]}"
  print "(Enter to skip) Change title to: "
  params[:title] = gets.chomp
  puts "Description: #{body["description"]}"
  print "(Enter to skip) Change description to: "
  params[:description] = gets.chomp
  puts "url: #{body["url"]}"
  print "(Enter to skip) Change url to: "
  params[:url] = gets.chomp
  puts "Product id: #{body["product_id"]}"
  print "(Enter to skip) Change product_id to: "
  params[:product_id] = gets.chomp
  params.delete_if { |_key, value| value.empty? }
  response = Unirest.patch("http://localhost:3000/v1/images/#{id}", parameters: params)
  body = response.body
  puts JSON.pretty_generate(body)
  puts
  print "[Enter] to Continue: "
  gets.chomp
end

def add_image
  params = {}
  print "Enter product id: "
  params[:product_id] = gets.chomp
  print "Enter title (ie: Shirt 1 - MD: Image 1): "
  params[:title] = gets.chomp
  print "Enter description: "
  params[:description] = gets.chomp
  print "Enter url: "
  params[:url] = gets.chomp
  response = Unirest.post("http://localhost:3000/v1/images", parameters: params)
  body = response.body
  puts JSON.pretty_generate(body)
  puts
  print "[Enter] to Continue: "
  gets.chomp
end

def update_in_stock
  params = {}
  print "Enter product id: "
  id = gets.chomp
  if id == ""
    print "Please enter valid id, [Enter] to continue: "
    gets.chomp
    return
  end
  body = Unirest.get("http://localhost:3000/v1/products/#{id}").body
  if body["id"] != nil
    if body["in_stock"] == nil
      print "In Stock is Nil, change? [Y/N]: "
      confirmation = gets.chomp
      if confirmation == "Y" || confirmation == "y"
        puts
        print "[1] to change 'In Stock' to True, [2] to change 'In Stock' to False: "
        choice = gets.chomp
        if choice == "1"
          params["in_stock"] = true
        elsif choice == "2"
          params["in_stock"] = false 
        else 
          puts "Invalid Choice [Any Key] to Start Over"
          gets.chomp
          return
        end
      end
    elsif body["in_stock"] == false
      print "In Stock is false, change to true? [Y/N]: "
      confirmation = gets.chomp
      if confirmation == "Y" || confirmation == "y"
        params["in_stock"] = true
      end
    elsif body["in_stock"] == true
      print "In Stock is true, change to false? [Y/N]: "
      confirmation = gets.chomp
      if confirmation == "Y" || confirmation == "y"
        params["in_stock"] = false
      end
    end
  else
    print "Product does not exist [Any Key] to Continue, 'q' to Quit: "
    gets.chomp
    return
  end
  response = Unirest.patch("http://localhost:3000/v1/products/#{id}", parameters: params)
  page = response.body
  puts JSON.pretty_generate(page)
  puts
  print "[Enter] to Continue: "
  gets.chomp
end

def delete_product
  print "Enter id: "
  product_id = gets.chomp
  if product_id == ""
    print "Please enter valid id, [Enter] to continue: "
    gets.chomp
    return
  end
  body = Unirest.get("http://localhost:3000/v1/products/#{product_id}").body
  puts JSON.pretty_generate(body)
  print "Are you sure you want to delete this product? [Y/N]: "
  confirmation = gets.chomp
  if confirmation == "Y" || confirmation == "y"
    body = Unirest.delete("http://localhost:3000/v1/products/#{product_id}").body
    puts body["message"]
    puts
  end
  print "[Enter] to Continue: "
  gets.chomp
end

while true do

  if @signin == false
    system "clear"
    puts "Welcome to the T-Shirt Shop!"
    puts
    puts "[Enter] To Login"
    puts "[Signup] To Signup"
    puts
    puts "[1] View all products"
    puts "[2] View all products in a table"
    puts "[3] View one product"
    puts "[4] Search products"
    puts "[5] View all products in a category"
    puts "To quit, type 'q'"

    print "Entry: "
    entry = gets.chomp
    if entry == ""
      login
      get_user_name
    elsif entry == "Signup" or entry == "signup" or entry == "sign up" or entry == "Sign up"
      signup
    elsif entry == "1"
      view_all
    elsif entry == "2"
      view_table
    elsif entry == "3"
      view_one
    elsif entry == "4"
      search
    elsif entry == "5"
      view_products_in_category
    elsif entry == "q"
      break
    end
  end

  if @signin == true && @admin == false
    system "clear"
    puts "*** Welcome #{@name} ***"
    puts
    puts "[1] View all products"
    puts "[2] View all products in a table"
    puts "[3] View one product"
    puts "[4] Search products"
    puts "[5] View all products in a category"
    puts "[6] Add items to cart"
    puts "[7] Remove items from cart"
    puts "[8] View cart"
    puts "[9] Order products in cart"
    puts "[10] See all past orders"
    puts "[logout] to Logout"
    puts "To quit, type 'q'"
    print "Entry: "
    entry = gets.chomp

    if entry == "1"
      view_all
    elsif entry == "2"
      view_table
    elsif entry == "3"
      view_one
    elsif entry == "4"
      search
    elsif entry == "5"
      view_products_in_category
    elsif entry == "6"
      add_items_to_cart
    elsif entry == "7"
      remove_item_from_cart
    elsif entry == "8"
      view_items_in_cart
    elsif entry == "9"
      order
    elsif entry == "10"
      see_orders
    elsif entry == "logout" or entry == "Logout" or entry == "log out"
      logout
    elsif entry == "q"
      break
    end
  end

  if @admin == true
    system "clear"
    puts "*** Welcome to the T-Shirt Shop Admin Portal, #{@name}! ***"
    puts
    puts "Please choose an option below:"
    puts "============================="
    puts "Shopping Options:"
    puts "[1] View all products"
    puts "[2] View all products in a table"
    puts "[3] View one product"
    puts "[4] Search products"
    puts "[5] View all products in a category"
    puts "[6] Add items to cart"
    puts "[7] Remove items from cart"
    puts "[8] View cart"
    puts "[9] Order products in cart"
    puts "[10] See all your past orders"
    puts "==================="
    puts "Admin Options:"
    puts "[11] Create a new product"
    puts "[12] Update a product"
    puts "[13] Update an image"
    puts "[14] Add Image"
    puts "[15] Change Stock"
    puts "[16] Delete a product"
    puts "======================  "
    puts "[logout] to Logout"
    puts "To quit, type 'q'"
    puts "============================="
    print "Entry: "
    entry = gets.chomp
    puts

    if entry == "1"
      view_all
    elsif entry == "2"
      view_table
    elsif entry == "3"
      view_one
    elsif entry == "4"
      search
    elsif entry == "5"
      view_products_in_category
    elsif entry == "6"
      add_items_to_cart
    elsif entry == "7"
      remove_item_from_cart
    elsif entry == "8"
      view_items_in_cart
    elsif entry == "9"
      order
    elsif entry == "10"
      see_orders
    elsif entry == "11"
      create_product
    elsif entry == "12"
      update_product
    elsif entry == "13"
      update_image
    elsif entry == "14"
      add_image
    elsif entry == "15"
      update_in_stock
    elsif entry == "16"
      delete_product
    elsif entry == "logout"
      logout
    elsif entry == "q"
      break
    end

  end

end