class CreateApp < ActiveRecord::Migration[7.0]
  def change
    enable_extension 'citext'

    create_table     :accounts do |t|
      t.integer      :status, null: false, default: 1
      t.citext       :email, null: false
      t.index        :email, unique: true, where: 'status IN (1, 2)'
      t.string       :password_hash
    end

    # Used by the password reset feature
    create_table     :account_password_reset_keys do |t|
      t.foreign_key  :accounts, column: :id
      t.string       :key, null: false
      t.datetime     :deadline, null: false
      t.datetime     :email_last_sent, null: false, default: -> { 'CURRENT_TIMESTAMP' }
    end

    # Used by the account verification feature
    create_table     :account_verification_keys do |t|
      t.foreign_key  :accounts, column: :id
      t.string       :key, null: false
      t.datetime     :requested_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.datetime     :email_last_sent, null: false, default: -> { 'CURRENT_TIMESTAMP' }
    end

    # Used by the verify login change feature
    create_table     :account_login_change_keys do |t|
      t.foreign_key  :accounts, column: :id
      t.string       :key, null: false
      t.string       :login, null: false
      t.datetime     :deadline, null: false
    end

    # Used by the remember me feature
    create_table     :account_remember_keys do |t|
      t.foreign_key  :accounts, column: :id
      t.string       :key, null: false
      t.datetime     :deadline, null: false
    end

    # Used by the email auth feature
    create_table     :account_email_auth_keys do |t|
      t.foreign_key  :accounts, column: :id
      t.string       :key, null: false
      t.datetime     :deadline, null: false
      t.datetime     :email_last_sent, null: false, default: -> { 'CURRENT_TIMESTAMP' }
    end

    # Profile
    create_table     :profiles do |t|
      t.string       :username, null: false, unique: true
      t.string       :firstname, null: false
      t.string       :lastname, null: false
      t.integer      :gender, default: 0
      t.text         :bio
      t.date         :birthdate
      t.string       :phone_number
      t.string       :phone_verification_code
      t.boolean      :phone_is_verified, default: 0
      t.references   :account, null: false, foreign_key: true

      t.timestamps
    end

    # Country
    create_table     :countries do |t|
      t.string       :name
      t.timestamps
    end

    # Region
    create_table     :regions do |t|
      t.string       :name
      t.decimal      :geo_lat,                      precision: 15, scale: 20
      t.decimal      :geo_lon,                      precision: 15, scale: 20
      t.references   :country, null: false, foreign_key: true
    
      t.timestamps
    end
    
    # City
    create_table     :cities do |t|
      t.string       :country_code
    
      t.timestamps
    end

    # Location
    create_table     :locations do |t|
      t.string       :country_code
      t.string       :country_name
      t.string       :country_name_en
      t.decimal      :country_geo_lat,                     precision: 15, scale: 10
      t.decimal      :country_geo_lon,                     precision: 15, scale: 10
      t.string       :country_region_full_address
      t.string       :country_region_name
      t.string       :country_region_fias_type
      t.string       :country_region_okato
      t.string       :country_region_oktmo
      t.decimal      :country_region_geo_lat,               precision: 15, scale: 10
      t.decimal      :country_region_geo_lon,               precision: 15, scale: 10
      t.string       :country_region_peoples
      t.string       :country_region_timezone
      t.string       :country_region_wiki
      t.string       :country_region_locality_full_address
      t.string       :country_region_locality_name
      t.string       :country_region_locality_fias
      t.string       :country_region_locality_fias_type
      t.string       :country_region_locality_type
      t.string       :country_region_locality_okato
      t.string       :country_region_locality_oktmo
      t.decimal      :country_region_locality_geo_lat,       precision: 15, scale: 10
      t.decimal      :country_region_locality_geo_lon,       precision: 15, scale: 10
      t.string       :country_region_locality_peoples
      t.string       :country_region_locality_timezone
      t.string       :country_region_locality_wiki
      t.references   :located, polymorphic: true, null: false
      t.references   :account, null: false, foreign_key: true
      t.references   :country, null: true, foreign_key: true
      t.references   :region, null: true, foreign_key: true
      t.references   :city, null: true, foreign_key: true

      t.timestamps
    end

    # Geopoint
    create_table :geopoints do |t|
      t.string       :geopoint_name
    
      t.timestamps
    end
    
  end
end
