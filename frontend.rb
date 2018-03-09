require "unirest"

system "clear"

while true do 
  puts "Welcome to the T-Shirt Shop!"
  puts "Please choose an option below:"
  puts "To view all products, type [1]"
  puts "To view all products in a table, type [2]"
  puts "To view one product, type [3]"
  puts "To create new products, type [4]"
  puts "To update a product, type [5]"
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
    print "Name: "
    params[:name] = gets.chomp
    print "Size: "
    params[:size] = gets.chomp
    print "Price: "
    params[:price] = gets.chomp
    print "Description: "
    params[:description] = gets.chomp
    params.delete_if { |_key, value| value.empty? }
    response = Unirest.patch("http://localhost:3000/v1/products/#{id}", parameters: params)
    page = response.body
    puts JSON.pretty_generate(page)
  elsif input == 'q'
    break
  end
end