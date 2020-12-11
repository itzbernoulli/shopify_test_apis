class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  require 'apis/shopify_apis'
  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user.auth_url }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def callback
    store =  params['shop']
    message = "code=#{params['code']}&shop=#{params['shop']}&state=#{params['state']}&timestamp=#{params['timestamp']}"
    user = User.find_by_store(store)
    #verify nonce and hmac values coming from shopify
    if (check_hmac(message) && user.check_nonce=params['state'])
      #retrieve shopify access token for customer
      #there should be a response check here incase response is an error
      response = ShopifyApi::Shopify.get_access_token(user, params['code'])

      if user.update_attributes(:access_token => response['access_token'], :scopes => response['scope'])
        GetCustomersJob.perform_later(user.id)
        redirect_to root_url
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:store, :nonce, :access_token)
    end

    def check_hmac(message)
      digest = OpenSSL::Digest.new('sha256')
      secret = "hush"
      message = "code=0907a61c0c8d55e99db179b68161bc00&shop=some-shop.myshopify.com&state=0.6784241404160823&timestamp=1337178173"

      digest = OpenSSL::HMAC.hexdigest(digest, secret, message)
      ActiveSupport::SecurityUtils.secure_compare(digest, "700e2dadb827fcc8609e9d5ce208b2e9cdaab9df07390d2cbca10d7c328fc4bf")
  end
end
