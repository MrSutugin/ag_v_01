class Profile < ApplicationRecord
  belongs_to :account
  validates :username, presence: true, format: {
    with: /\A(?=.{3,28}\z)[a-zA-Z0-9]+(?:[._][a-zA-Z0-9]+)*\z/,
    message: 'Логин может использовать латинские буквы,
      цифры, подчеркивания (_) и точки (.)'
  }, uniqueness: true
end
