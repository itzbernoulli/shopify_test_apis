json.extract! user, :id, :store, :nonce, :access_token, :created_at, :updated_at
json.url user_url(user, format: :json)
