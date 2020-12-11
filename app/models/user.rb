class User < ApplicationRecord
    has_many :customers, dependent: :destroy

    validates :store, format: { with: /[a-zA-Z0-9][a-zA-Z0-9\-]*\.myshopify\.com[\/]?/, message: "shopify url in invalid." }
    validates_uniqueness_of :store

    before_save :generate_nonce

    def auth_url
        api_key = ENV['SHOPIFY_API_KEY']
        scopes = 'read_customers'
        redirect_uri = 'https://localhost:3000/auth/shopify/callback'
        'https://'+ self.store + '/admin/oauth/authorize?client_id='+ ENV['SHOPIFY_API_KEY'] +'&scope='+ scopes + '&redirect_uri='+ redirect_uri +'&state='+ self.nonce + '&grant_options[]='
    end

    def check_nonce=(nonce)
        nonce.eql? self.nonce
    end

    private 
    def generate_nonce
        self.nonce = SecureRandom.uuid[0..5]
    end


end
