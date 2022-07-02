class Activity < ApplicationRecord
  belongs_to :account
  belongs_to :trackable, polymorphic: true
end