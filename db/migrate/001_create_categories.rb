class CreateCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :categories do |t|
      t.string   :name, null: false
      t.string   :slug
      t.string   :ancestry

      t.timestamps
    end
    add_index :categories, :ancestry
  end
end
