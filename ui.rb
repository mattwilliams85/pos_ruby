require 'rspec'
require 'active_record'
require 'shoulda-matchers'
require 'pry'

require './lib/clerk'
require './lib/item'
require './lib/transaction'
require './lib/purchase'

require './transaction_ui'
require './inventory_ui'

database_configuration = YAML::load(File.open('./db/config.yml'))
development_configuration = database_configuration["development"]
ActiveRecord::Base.establish_connection(development_configuration)

@input = nil
@current_clerk = nil

def header
	system 'clear'
	puts "[==== Sales Register ====]"
	puts "User: #{@current_clerk.name if @current_clerk != nil}"
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
	result = name + "' have" if name[-1] == 's' && quantity.to_i > 1
	return result
end

def list_items
	puts "-------------------"
	Item.all.sort.each {|i| puts "#(#{i.id}) #{i.name} - $#{i.price}"}
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
			login_menu
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
				puts "\n"
				puts "Welcome #{name}!"
				@current_clerk = clerk
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
		until @input == '5'
		header
		puts "1 > New Transaction"
		puts "2 > Add Inventory"
		puts "3 > Update Inventory"
		puts "4 > View recent sales"
		puts "5 > Return to Main Menu"
		@input = gets.chomp
		case @input
		when '1'
			new_transaction
		when '2'
			add_inventory
		when '3'
			update_inventory
		when '4'
			recent_sales
		when '5'
			@current_clerk = nil
			main_menu
		else 
			invalid 
		end
	end
end

def recent_sales
	puts "-------------------"
	Purchase.today.each do |purchase|
		item = Item.find(purchase.item_id)
		puts "(##{item.id}) #{purchase.quantity}x #{item.name} = $#{sprintf("%.2f",(purchase.total))}"
	end
	puts "-------------------"
	puts "Hit [ENTER] to continue..."
	gets
end

main_menu







