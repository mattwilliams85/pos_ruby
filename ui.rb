require 'rspec'
require 'active_record'
require 'shoulda-matchers'
require 'pry'

require './lib/clerk'
require './lib/item'
require './lib/purchase'
require './lib/transaction'

@input = nil

def header
	system 'clear'
	puts "[==== Sales Register ====]"
	puts "\n"
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
			#clerk_menu
		when '2'
			#new_user
		when '3'
			puts "Thank you, come again!"
			exit
		end
	end
end

main_menu