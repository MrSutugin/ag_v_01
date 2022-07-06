class CreateGigs < ActiveRecord::Migration[7.0]
  def change
    create_table   :gigs do |t|
      t.string     :name
      t.text       :bio
      t.decimal    :price
      t.string     :slug
      t.references :account, null: false, foreign_key: true
      t.references :gigsable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
