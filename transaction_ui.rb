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
			cancel_transaction
			clerk_menu
		else 
			invalid 
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
	total = quantity.to_f * item.price.to_f
	name = singular?(item.name,quantity)
	Purchase.create(:item_id => id, :transaction_id => @transaction.id, :quantity => quantity, :total => total)
	puts "#{quantity} #{name} been added to cart!"
	long_wait
end

def view_cart
	puts "-------------------"
	Purchase.where(:transaction_id => @transaction.id).each do |purchase|
		item = Item.find(purchase.item_id)
		puts "(##{item.id}) #{purchase.quantity}x #{item.name} = $#{sprintf("%.2f",(purchase.total))}"
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

def checkout
	Transaction.find(@transaction.id).update(:total => Purchase.sum(:total), :clerk_id => @current_clerk.id)
	view_cart
	puts "TOTAL >> $#{sprintf("%.2f",(Purchase.where(:transaction_id => @transaction.id).sum(:total)))}"
	puts "\n"
	until @input == '2'
		puts "1 > Confirm Total"
		puts "2 > Return to Transaction Menu"
		@input = gets.chomp
		case @input
		when '1'
			puts "Transaction Complete! Hit [ENTER] to continue.."
			gets
			clerk_menu
		when '2'
		else 
			invalid
		end
	end
end

def cancel_transaction
	puts "Your cart has been cleared"
	Purchase.where(:transaction_id => @transaction.id).destroy_all
	@transaction.destroy
	wait
end
