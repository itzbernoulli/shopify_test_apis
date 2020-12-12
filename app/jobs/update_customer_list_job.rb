class UpdateCustomerListJob < ApplicationJob
  queue_as :default

  def perform(id)
    # Do something later
    user = User.find_by_id(id)
    ShopifyApi::Shopify.update_store_customer_list(user)
  end
end
