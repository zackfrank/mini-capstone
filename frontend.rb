require "unirest"

system "clear"

while true do 
  puts "Welcome to the T-Shirt Shop!"
  puts "Please choose an option below:"
  puts "To view all products, type [1]"
  puts "To quit, type 'q'"
  input = gets.chomp

  if input == "1"
    response = Unirest.get("http://localhost:3000/all-products")
    page = response.body

    puts JSON.pretty_generate(page)
  elsif input == 'q'
    break
  end
end