class Purchase < ActiveRecord::Base
	validate :greater_than_zero
	validates :quantity, :presence => :true

	def greater_than_zero
	    if quantity == 0
	      errors.add(:quantity, "can't be less than zero")
	    end
  	end

end
