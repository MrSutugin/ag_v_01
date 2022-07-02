class Profile < ApplicationRecord
  belongs_to :account
  has_many :activities, as: :trackable, dependent: :destroy
end
