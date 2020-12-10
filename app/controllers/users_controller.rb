class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

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
    p params['code']
    p params['hmac']
    store =  params['shop']
    p params['state']
    p params['timestamp']

        body = {
              "client_id": ENV['SHOPIFY_API_KEY'],
              "client_secret": ENV['SHOPIFY_API_SECRET_KEY'],
              "code": params['code']
        }
        url = URI("https://#{params['shop']}/admin/oauth/access_token")
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        p url
        p http

        request = Net::HTTP::Post.new(url)
        request["content-type"] = 'application/json'
        request["cache-control"] = 'no-cache'
        request.body = body.to_json

        response = JSON.parse(http.request(request).body)

        user = User.find_by_store(store)
        if user.update_attributes(:access_token => response['access_token'], :scopes => response['scope'])
          # p 'updated successfully'
          GetCustomersJob.perform_later(user.id)
          redirect_to root_path
        end
        # p store
        # p response['access_token']
        # p response['scope']
        # p response
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
end
