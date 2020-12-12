module ShopifyApi
  class Shopify

    HTTP_ERRORS = [
        Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError,
        Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError
      ]

    OAUTH_URL = "/admin/oauth/access_token"
    CUSTOMERS_URL = "/admin/api/2020-10/customers.json"


    def self.get_access_token(user, code)
      begin
        body = {
          "client_id": ENV['SHOPIFY_API_KEY'],
          "client_secret": ENV['SHOPIFY_API_SECRET_KEY'],
          "code": code
        }
        url = URI("https://#{user.store}" + OAUTH_URL)
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        request = Net::HTTP::Post.new(url)
        request["content-type"] = 'application/json'
        request["cache-control"] = 'no-cache'
        request.body = body.to_json

        response = JSON.parse(http.request(request).body)
      
      rescue *HTTP_ERRORS => error
          raise
      end
    end


    def self.get_store_customers(user)
        begin
            url = URI("https://#{user.store}" + CUSTOMERS_URL + "?fields=first_name,last_name,email,")
            http = Net::HTTP.new(url.host, url.port)
            http.use_ssl = true
            http.verify_mode = OpenSSL::SSL::VERIFY_NONE
            request = Net::HTTP::Get.new(url)
            request["cache-control"] = 'no-cache'

            request["X-Shopify-Access-Token"] = user.access_token
            response = http.request(request)

            verification_response = JSON.parse(response.body)
            Customer.insert_all(
              verification_response['customers'], user.id
            )
        rescue *HTTP_ERRORS => error
            raise
        end
    end

  end
end