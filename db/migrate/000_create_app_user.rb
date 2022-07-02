class CreateAppUser < ActiveRecord::Migration[7.0]
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
      t.string       :firstname
      t.string       :lastname
      t.integer      :gender, default: 0
      t.text         :bio
      t.date         :birthdate
      t.references   :account, null: false, foreign_key: true

      t.timestamps
    end

    # Phone
    create_table     :phones do |t|
      t.string       :phone_number
      t.string       :phone_verification_code
      t.boolean      :phone_is_verified, default: 0
      t.references   :account, null: false, foreign_key: true

      t.timestamps
    end
    
    # Activity
    create_table     :activities do |t|
      t.string       :message
      t.references   :trackable, polymorphic: true, null: false
      t.references   :account, null: false, foreign_key: true

      t.timestamps
    end
  end
end
