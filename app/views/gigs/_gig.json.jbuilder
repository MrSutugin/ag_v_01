json.extract! gig, :id, :name, :bio, :price, :slug, :account_id, :gigsable_id, :gigsable_type, :created_at, :updated_at
json.url gig_url(gig, format: :json)
