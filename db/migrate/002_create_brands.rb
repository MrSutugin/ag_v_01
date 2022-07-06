class CreateBrands < ActiveRecord::Migration[7.0]
  def change
    create_table   :brands do |t|
      t.string     :name
      t.text       :bio
      t.string     :slug
      t.references :account, null: false, foreign_key: true

      t.timestamps
    end
  end
end
