module ShopifyApi
  class Shopify
    require 'apis/shopify_request'
    HTTP_ERRORS = [
      Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError,
      Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError
    ].freeze

    OAUTH_URL = '/admin/oauth/access_token'.freeze
    CUSTOMERS_URL = '/admin/api/2020-10/customers.json?fields=first_name,last_name,email'.freeze
    
    def self.get_access_token(user, code)
      begin
        body = { "client_id": ENV['SHOPIFY_API_KEY'], "client_secret": ENV['SHOPIFY_API_SECRET_KEY'], "code": code }
        url = URI("https://#{user.store}" + OAUTH_URL)
        ShopifyRequest.get_token(url, body)
      rescue *HTTP_ERRORS
        raise
      end
    end

    def self.get_store_customers(user)
      begin
        url = URI("https://#{user.store}" + CUSTOMERS_URL)
        verification_response = ShopifyRequest.get_request(url, user)
        if verification_response['customers'].count.positive?
          Customer.insert_all(verification_response['customers'], user.id)
          user.update_attribute(:last_customer_update_time, DateTime.now)
        end
      rescue *HTTP_ERRORS
        raise
      end
    end

    def self.update_store_customer_list(user)
      begin
        url = URI("https://#{user.store}#{CUSTOMERS_URL}&created_at_min=
        #{user.last_customer_update_time}&updated_at_min=#{user.last_customer_update_time}")
        verification_response = ShopifyRequest.get_request(url, user)
        if verification_response['customers'].count.positive?
          Customer.upsert_all(verification_response['customers'], user.id)
          user.update_attribute(:last_customer_update_time, DateTime.now)
        end
      rescue *HTTP_ERRORS
        raise
      end
    end

  end
end