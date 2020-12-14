module ShopifyApi
  class Shopify
    class << self
      require 'apis/shopify_request'

      ACTIONS = [CREATE = 'create'.freeze, UPDATE = 'update'.freeze].freeze

      HTTP_ERRORS = [
        Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError,
        Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError
      ].freeze

      OAUTH_URL = '/admin/oauth/access_token'.freeze
      CUSTOMERS_URL = '/admin/api/2020-10/customers.json?fields=first_name,last_name,email'.freeze
      
      def get_access_token(user, code)
        begin
          body = { "client_id": ENV['SHOPIFY_API_KEY'], "client_secret": ENV['SHOPIFY_API_SECRET_KEY'], "code": code }
          url = URI("https://#{user.store}" + OAUTH_URL)
          ShopifyRequest.get_token(url, body)
        rescue *HTTP_ERRORS
          raise
        end
      end

      def get_store_customers(user)
        begin
          url = URI("https://#{user.store}" + CUSTOMERS_URL)
          create_or_update_customers(CREATE, ShopifyRequest.get_request(url, user), user)
        rescue *HTTP_ERRORS
          raise
        end
      end

      def update_store_customer_list(user)
        begin
          url = URI("https://#{user.store}#{CUSTOMERS_URL}&created_at_min=
          #{user.last_customer_update_time}&updated_at_min=#{user.last_customer_update_time}")
          create_or_update_customers(UPDATE, ShopifyRequest.get_request(url, user), user)
        rescue *HTTP_ERRORS
          raise
        end
      end

      private 
      
      def update_user(user)
        user.update_attribute(:last_customer_update_time, DateTime.now)
      end

      def create_or_update_customers(action, response, user)
        return unless response['customers'].count.positive?

        if action.eql? CREATE
          Customer.insert_all(response['customers'], user.id)
        else
          Customer.upsert_all(response['customers'], user.id)
        end
        update_user(user)
      end
    end
  end
end