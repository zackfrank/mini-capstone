require "unirest"

system "clear"

while true do 
  puts "Welcome to the T-Shirt Shop!"
  puts "Please choose an option below:"
  puts "To view all products, type [1]"
  puts "To view all products in a table, type [2]"
  puts "To quit, type 'q'"
  input = gets.chomp

  if input == "1"
    response = Unirest.get("http://localhost:3000/v1/all-products")
    page = response.body
    puts JSON.pretty_generate(page)
  elsif input == "2"
    response = Unirest.get("http://localhost:3000/v1/all-products")
    page = response.body
    table = TTY::Table.new ['Name', 'Size', 'Price'], [page[0]["name"], page[0]["size"], page[0]["price"]], [page[1]["name"], page[1]["size"], page[1]["price"]]
    table.render(:ascii)
  elsif input == 'q'
    break
  end
end