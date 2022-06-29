class Location < ApplicationRecord
  belongs_to :located, polymorphic: true
  belongs_to :account
  belongs_to :country
  belongs_to :region
  belongs_to :city
end
