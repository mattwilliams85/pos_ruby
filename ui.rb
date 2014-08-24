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

# def singular?
#   @name = @name + "s have" 
# 	@name = @name + " has" if @quantity.to_i == 1
# end

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







