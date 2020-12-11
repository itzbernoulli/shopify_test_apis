class GetCustomersJob < ApplicationJob
  queue_as :default
  require 'apis/shopify_apis'

  def perform(id)
    # Do something later
    user = User.find_by_id(id)
    ShopifyApi::Shopify.get_store_customers(user)
  end
end
