class PurchasesAddColumnTimestamps < ActiveRecord::Migration
  def change 
  	change_table :purchases do |t|
  		t.timestamps
  	end
  end
end
