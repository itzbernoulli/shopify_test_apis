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
    user = User.find_by_store(store)
    if (check_hmac(construct_message(params), params['hmac']) && user.check_nonce=params['state'])
      #retrieve shopify access token for customer
      response = ShopifyApi::Shopify.get_access_token(user, params['code'])
      if user.update_attributes(:access_token => response['access_token'], :scopes => response['scope'])
        GetCustomersJob.perform_later(user.id)
        redirect_to root_url
      else
        destroy_user_and_redirect= user, 'Failed to retrieve Access Token. Please try again'
      end
    else
      destroy_user_and_redirect= user, 'Link Verification failed. Please try again'
    end
  end

  private
    def destroy_user_and_redirect=(user, message)
      user.destroy
      redirect_to root_url, notice: message
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:store, :nonce, :access_token)
    end

    def check_hmac(message,hmac)
      digest = OpenSSL::Digest.new('sha256')
      secret = ENV['SHOPIFY_API_SECRET_KEY']
      digest = OpenSSL::HMAC.hexdigest(digest, secret, message)
      ActiveSupport::SecurityUtils.secure_compare(digest, hmac)
  end
end
