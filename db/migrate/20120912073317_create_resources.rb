class CreateResources < ActiveRecord::Migration
  def change
    create_table :resources do |t|
      t.string :name, null: false
      t.string :database, null: false
      t.string :collection, null: false
      t.text :description

      t.timestamps
    end
  end
end
