class GetCustomersJob < ApplicationJob
  queue_as :default

  def perform(id)
    # Do something later
    user = User.find_by_id(id)
    url = URI("https://#{user.store}/admin/api/2020-10/customers.json")

           http = Net::HTTP.new(url.host, url.port)
           http.use_ssl = true
           http.verify_mode = OpenSSL::SSL::VERIFY_NONE

           request = Net::HTTP::Get.new(url)
           request["X-Shopify-Access-Token"] = user.access_token
           request["cache-control"] = 'no-cache'

    		response = http.request(request)
        verification_response = JSON.parse(response.body)
        
        p verification_response

        verification_response['customers'].each do |c| 
          Customer.create(
            user_id: user.id,
            first_name: c[:first_name],
            last_name: c[:last_name],
            Email: c[:email],
          )
        end
  end
end
