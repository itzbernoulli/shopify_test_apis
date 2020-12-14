class ShopifyRequest
  class << self
    METHOD = [GET = 'get'.freeze, POST = 'post'.freeze].freeze

    def get_token(url, body)
      parsed_response(http(url).request(request(POST, url, headers, body)))
    end

    def get_request(url, user)
      new_header = headers.merge('X-Shopify-Access-Token' => user.access_token )
      parsed_response(http(url).request(request(GET, url, new_header)))
    end

    private

    def http(url)
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      http
    end

    def request(method, url, headers, body = {})
      if method.eql? GET
        request = Net::HTTP::Get.new(url)
      else
        request = Net::HTTP::Post.new(url)
      end
      headers.each { |key, value| request["#{key}"] = "#{value}" }
      request.body = body.to_json unless body.blank?
      request
    end

    def parsed_response(response)
      JSON.parse(response.body)
    end

    def headers
      { 'cache-control' => 'no-cache', 'content-type' => 'application/json' }
    end

  end
end
