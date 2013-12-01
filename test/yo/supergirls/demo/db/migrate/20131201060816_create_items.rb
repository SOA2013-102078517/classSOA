class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name
      t.integer :price
      t.string :image
      t.text :description
      t.text :discussion

      t.timestamps
    end
  end
end
