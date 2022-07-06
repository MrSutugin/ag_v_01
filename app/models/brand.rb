class Brand < ApplicationRecord
  belongs_to :account

  validates :name, presence: { message: 'Название не может быть пустым' }
end
