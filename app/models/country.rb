class Country < ApplicationRecord
  has_many :regions
  has_many :cities
  has_many :locations
end