require "unirest"
require "tty-table"
require "tty-prompt"

while true do 
  system "clear"
  puts "Welcome to the T-Shirt Shop!"
  puts "Please choose an option below:"
  puts
  puts "[Enter] To Login"
  puts "[Signup] Sign up"
  puts "[Order] Order products"
  puts "[See all] See all orders"
  puts "[1] View all products"
  puts "[2] View all products in a table"
  puts "[3] View one product"
  puts "[4] Search products"
  puts "[5] Create new products"
  puts "[6] Update a product"
  puts "[7] Update an image"
  puts "[8] Add Image"
  puts "[9] Change Stock"
  puts "[10] Delete a product"
  puts "[logout] to Logout"
  puts "To quit, type 'q'"
  puts
  print "Entry: "
  input = gets.chomp
  puts

  if input == ""
    prompt = TTY::Prompt.new
    print "Please enter your email: "
    email = gets.chomp
    password = prompt.mask "Please enter password: "

    response = Unirest.post(
      "http://localhost:3000/user_token",
      parameters: {
        auth: {
          email: email,
          password: password
        }
      }
    )

    # Save the JSON web token from the response
    jwt = response.body["jwt"]
    # Include the jwt in the headers of any future web requests
    Unirest.default_header("Authorization", "Bearer #{jwt}")
    puts "Welcome! Your jwt is #{jwt}"
    puts
    print "[Enter] to Continue: "
    gets.chomp
  elsif input == "signup" or input == "Signup" or input == "sign up" # Create a user
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
    if gets.chomp == 'q'
      break
    end
  elsif input == "logout"
    puts "You can login, but you can't logout"
    puts
    gets.chomp
    jwt = ''
    Unirest.clear_default_headers()
    puts "Just kidding. You're now logged out."
    puts
    print "[Enter] to Continue: "
    gets.chomp
  elsif input == "order" or input == "Order"
    params = {}
    print "Product id of product you'd like to order: "
    params["product_id"] = gets.chomp
    print "Quantity: "
    params["quantity"] = gets.chomp
    response = Unirest.post("http://localhost:3000/v1/orders", parameters: params)
    body = response.body
    puts JSON.pretty_generate(body)
    puts
    print "[Enter] to continue"
    gets.chomp
  elsif input == "seeall" or input == "See all" or input == "see all" or input == "Seeall"
    response = Unirest.get("http://localhost:3000/v1/orders")
    body = response.body
    puts JSON.pretty_generate(body)
    print "[Enter] to continue: "
    gets.chomp
  elsif input == "1" # View All Products
    print "Order by [1]id or [2]price?: "
    choice = gets.chomp
    if choice == "1"
      order_by = "id"
    elsif choice == "2"
      order_by = "price"
    end
    response = Unirest.get("http://localhost:3000/v1/products?order_by=#{order_by}")
    page = response.body
    puts JSON.pretty_generate(page)
    puts
    print "[Enter] to Continue ('q' to Quit): "
    if gets.chomp == 'q'
      break
    end
  elsif input == "2" # View All Products in Table
    response = Unirest.get("http://localhost:3000/v1/products")
    page = response.body
    table = TTY::Table.new [
      'Name', 
      'Size', 
      'Price'
      ], 
      [
        [
          page[0]["name"], 
          page[0]["size"], 
          page[0]["price"]
        ], 
        [
          page[1]["name"], 
          page[1]["size"], 
          page[1]["price"]
        ],
        
      ]

    # table = TTY::Table.new ['header1','header2'], [['a1', 'a2'], ['b1', 'b2']]
    puts table.render(:unicode)
    puts
    print "[Enter] to Continue ('q' to Quit): "
    if gets.chomp == 'q'
      break
    end
  elsif input == "3" # View one product
    print "Enter a product id: "
    id = gets.chomp
    response = Unirest.get("http://localhost:3000/v1/products/#{id}")
    page = response.body
    system "clear"
    puts JSON.pretty_generate(page)
    puts
    print "[Enter] to Continue ('q' to Quit): "
    if gets.chomp == 'q'
      break
    end
  elsif input == "4" # Search
    while true
      print "Enter Search Query: "
      search = gets.chomp
      response = Unirest.get("http://localhost:3000/v1/products?search=#{search}")
      page = response.body
      puts JSON.pretty_generate(page)
      puts
      print "[Enter] to Search again ([1] to Go to Main Menu): "
      if gets.chomp == '1'
        break
      end
    end
  elsif input == "5" # Create new product
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
    print "[Any Key] to Continue ('q' to Quit): "
    if gets.chomp == 'q'
      break
    end
  elsif input == "6" # Update product
    print "Product id: "
    id = gets.chomp
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
    print "[Enter] to Continue ('q' to Quit): "
    if gets.chomp == 'q'
      break
    end
  elsif input == "7" # Update an image
    params = {}
    print "Image id: "
    id = gets.chomp
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
    print "[Enter] to Continue ('q' to Quit): "
    if gets.chomp == 'q'
      break
    end
  elsif input == "8" # Add a photo
  elsif input == "9" # Update in-stock only
    params = {}
    print "Enter id: "
    id = gets.chomp
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
            break
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
      input = gets.chomp
      if input == 'q'
        break
      else
        next 
      end
    end
    response = Unirest.patch("http://localhost:3000/v1/products/#{id}", parameters: params)
    page = response.body
    puts JSON.pretty_generate(page)
    puts
    print "[Enter] to Continue ('q' to Quit): "
    if gets.chomp == 'q'
      break
    end
  elsif input == "10" # Delete Product
    print "Enter id: "
    product_id = gets.chomp
    body = Unirest.get("http://localhost:3000/v1/products/#{product_id}").body
    puts JSON.pretty_generate(body)
    print "Are you sure you want to delete this product? [Y/N]: "
    confirmation = gets.chomp
    if confirmation == "Y" || confirmation == "y"
      body = Unirest.delete("http://localhost:3000/v1/products/#{product_id}").body
      puts body["message"]
    end
  elsif input == 'q'
    break
  end
end