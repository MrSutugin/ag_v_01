class Gig < ApplicationRecord
  belongs_to :account
  belongs_to :gigsable, polymorphic: true
end
