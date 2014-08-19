class CreateTables < ActiveRecord::Migration
  def change
    create_table :clerks do |t|
      t.column :name, :varchar
      t.column :password, :varchar
    end

    create_table :items do |t|
      t.column :name, :varchar
      t.column :price, :float
    end

    create_table :purchases do |t|
      t.column :item_id, :int
      t.column :transaction_id, :int
      t.column :quantity, :int
    end

    create_table :transactions do |t|
      t.column :clerk_id, :int
      t.column :total, :float
    end

  end
end
