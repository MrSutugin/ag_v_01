class Account < ApplicationRecord
  include Rodauth::Rails.model
  enum :status, unverified: 1, verified: 2, closed: 3
  has_one  :profile
  has_one  :phone
  has_many :activities
  has_many :brands
end
