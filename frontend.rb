require "unirest"

system "clear"

while true do 
  puts "Welcome to the T-Shirt Shop!"
  puts "Please choose an option below:"
  puts "[1] View all products"
  puts "[2] View all products in a table"
  puts "[3] View one product"
  puts "[4] Create new products"
  puts "[5] Update a product"
  puts "[6] Delete a product"
  puts "To quit, type 'q'"
  input = gets.chomp

  if input == "1"
    response = Unirest.get("http://localhost:3000/v1/products")
    page = response.body
    puts JSON.pretty_generate(page)
  elsif input == "2"
    response = Unirest.get("http://localhost:3000/v1/products")
    page = response.body
    table = TTY::Table.new ['Name', 'Size', 'Price'], [page[0]["name"], page[0]["size"], page[0]["price"]], [page[1]["name"], page[1]["size"], page[1]["price"]]
    table.render(:ascii)
  elsif input == "3"
    print "Enter a product id: "
    id = gets.chomp
    response = Unirest.get("http://localhost:3000/v1/products/#{id}")
    page = response.body
    puts JSON.pretty_generate(page)
  elsif input == "4"
    params = {}
    print "Name: "
    params[:name] = gets.chomp
    print "Size: "
    params[:size] = gets.chomp
    print "Price: "
    params[:price] = gets.chomp
    print "Description: "
    params[:description] = gets.chomp
    response = Unirest.post("http://localhost:3000/v1/products", parameters: params)
    page = response.body
    puts JSON.pretty_generate(page)
  elsif input == "5"
    print "Product id: "
    id = gets.chomp
    params = {}
    current_page = Unirest.get("http://localhost:3000/v1/products/#{id}").body
    puts "Name: " + current_page["name"]
    print "(Enter to skip) Change name to: "
    params[:name] = gets.chomp
    puts "Size: " + current_page["size"]
    print "(Enter to skip) Change size to: "
    params[:size] = gets.chomp
    puts "Price: " + current_page["price"].to_s
    print "(Enter to skip) Change price to: "
    params[:price] = gets.chomp
    puts "Description: " + current_page["description"]
    print "(Enter to skip) Change description to: "
    params[:description] = gets.chomp
    params.delete_if { |_key, value| value.empty? }
    response = Unirest.patch("http://localhost:3000/v1/products/#{id}", parameters: params)
    page = response.body
    puts JSON.pretty_generate(page)
  elsif input == "6"
    print "Enter id:"
    product_id = gets.chomp
    body = Unirest.get("http://localhost:3000/v1/products/#{product_id}").body
    puts JSON.pretty_generate(body)
    print "Are you sure you want to delete this product? [Y/N]"
    confirmation = gets.chomp
    if confirmation == "Y" || confirmation == "y"
      body = Unirest.delete("http://localhost:3000/v1/products/#{product_id}").body
      puts body["message"]
    end
  elsif input == 'q'
    break
  end
end