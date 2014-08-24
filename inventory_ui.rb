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