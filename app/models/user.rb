class User < ApplicationRecord
    has_many :customers, dependent: :destroy


    def auth_url
        api_key = ENV['SHOPIFY_API_KEY']
        scopes = 'read_customers'
        redirect_uri = 'https://localhost:3000/auth/shopify/callback'
        nonce = 'ABCDEF'
        'https://'+ self.store + '/admin/oauth/authorize?client_id='+ ENV['SHOPIFY_API_KEY'] +'&scope='+ scopes +'&redirect_uri='+ redirect_uri +'&state='+ nonce +'&grant_options[]='
    end
end
