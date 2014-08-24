class PurchasesAddColunn < ActiveRecord::Migration
  def change 
  	change_table :purchases do |t|
  		t.column :total, :float
  	end
  end
end
