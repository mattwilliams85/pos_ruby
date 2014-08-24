require 'rspec'
require 'active_record'
require 'shoulda-matchers'
require 'pry'

require './lib/clerk'
require './lib/item'
require './lib/purchase'
require './lib/transaction'

database_configuration = YAML::load(File.open('./db/config.yml'))
development_configuration = database_configuration["development"]
ActiveRecord::Base.establish_connection(development_configuration)

@input = nil

def header
	system 'clear'
	puts "[==== Sales Register ====]"
	puts "\n"
end

def invalid
	puts "Invalid Entry!" 
	puts "\n"
	puts "Hit [ENTER] to try again..."
	gets.chomp
end

def wait
	sleep 0.85
end 

def long_wait
	sleep 1.5
end 

def singular?(name, quantity)
  result = name + "s have" 
	result = name + " has" if quantity.to_i == 1
	result = name + "' have" if name(-1) == s && quantity.to_i > 1
	return result
end

def list_items
	puts "-------------------"
	Item.all.sort.each {|i| puts "##{i.id} - #{i.name}"}
	puts "-------------------"
end

def main_menu
	until @input == '3'
		header
		puts "1 > Login"
		puts "2 > Create New User"
		puts "3 > Quit"
		@input = gets.chomp
		case @input
		when '1'
			## RETURN TO login_menu after development
			clerk_menu
		when '2'
			new_user
		when '3'
			puts "Thank you, come again!"
			exit
		else 
			invalid 
			main_menu
		end
	end
end

def new_user
	header
	puts "Please enter new user name:"
	name = gets.chomp
	puts "Please enter new user password:"
	password = gets.chomp
	new_clerk = Clerk.new(name: name, password: password)
	if new_clerk.save
		puts "#{name} is now a registered user!"
		wait
	else
		new_clerk.errors.full_messages.each { |message| puts message }
		wait
	end
end

def login_menu
	header
	puts "Name:"
	name = gets.chomp
	Clerk.all.each do |clerk|
		if clerk.name == name
			puts "Password:"
			password = gets.chomp
			if clerk.password == password
				puts "Welcome #{name}!"
				wait
				clerk_menu
			else 
				puts "Password incorrect"
				wait
				main_menu
			end
		end
	end
	puts "Name incorrect"
	wait
	main_menu
end

def clerk_menu
		until @input == '4'
		header
		puts "1 > New Transaction"
		puts "2 > Add Inventory"
		puts "3 > Update Inventory"
		puts "4 > Return to Main Menu"
		@input = gets.chomp
		case @input
		when '1'
			new_transaction
		when '2'
			add_inventory
		when '3'
			update_inventory
		when '4'
			main_menu
		else 
			invalid 
			main_menu
		end
	end
end

def new_transaction
	@transaction = Transaction.create
	until @input == 'x'
		header
		puts ":TRANSACTION ##{@transaction.id}:"
		puts "1 > Add Item to Cart"
		puts "2 > Remove Item from Cart"
		puts "3 > View Cart"
		puts "4 > Checkout"
		puts "X > Cancel Transaction"
		@input = gets.chomp
		case @input.downcase
		when '1'
			add_to_cart
		when '2'
			remove_from_cart
		when '3'
			view_cart
			puts "Hit [ENTER] to continue.."
			gets
		when '4'
			checkout
		when 'x'
			puts "Your cart has been cleared"
			wait
			main_menu
		end
	end
end

def add_to_cart
	list_items
	puts "Enter the item # to add to cart:"
	id = gets.chomp.to_i
	puts "Enter the quantity of item:"
	quantity = gets.chomp
	item = Item.find(id)
	name = singular?(item.name,quantity)
	Purchase.create(:item_id => id, :transaction_id => @transaction.id, :quantity => quantity)
	binding.pry
	puts "#{quantity} #{name} been added to cart!"
	long_wait
end

def view_cart
	puts "-------------------"
	Purchase.all.each do |purchase|
		item = Item.find(purchase.item_id)
		puts "(##{item.id}) #{purchase.quantity}x #{item.name} = $#{sprintf("%.2f",(purchase.quantity * item.price))}"
	end
	puts "-------------------"
end

def remove_from_cart
	view_cart
	puts "Please enter the # of the item to remove"
	item_id = gets.chomp.to_i
	Purchase.find_by(:item_id => item_id).destroy
	puts "Item has been removed!"
	wait
end

# def checkout
# 	Purchase.
# end

def add_inventory
	puts "Enter the name of your new item (singular):"
	name = gets.chomp.downcase.capitalize
	puts "Enter the price of item (0.00):"
	price = gets.chomp
	Item.create({:name => name, :price => price})
	puts "'#{name}' for $#{price} has been added to the inventory!"
	long_wait
end

def update_inventory
	list_items
	puts "Enter the # of the item to update:"
	id = gets.chomp.to_i
	puts "Enter the new name of the item:"
	new_name = gets.chomp.downcase.capitalize
	puts "Enter the new price for the item (0.00):"
  new_price = gets.chomp
  Item.find(id).update(:name => new_name, :price => new_price)
  puts "Item ##{id} will now be #{new_name} for $#{new_price}!"
  long_wait
end

main_menu







