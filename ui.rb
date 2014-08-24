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

end

main_menu







