class LikesController < ApplicationController
  before_action :current_user_must_be_like_user, only: [:edit, :update, :destroy] 

  before_action :set_like, only: [:show, :edit, :update, :destroy]

  # GET /likes
  def index
    @likes = current_user.likes.page(params[:page]).per(10)
  end

  # GET /likes/1
  def show
  end

  # GET /likes/new
  def new
    @like = Like.new
  end

  # GET /likes/1/edit
  def edit
  end

  # POST /likes
  def create
    @like = Like.new(like_params)

    if @like.save
      message = 'Like was successfully created.'
      if Rails.application.routes.recognize_path(request.referrer)[:controller] != Rails.application.routes.recognize_path(request.path)[:controller]
        redirect_back fallback_location: request.referrer, notice: message
      else
        redirect_to @like, notice: message
      end
    else
      render :new
    end
  end

  # PATCH/PUT /likes/1
  def update
    if @like.update(like_params)
      redirect_to @like, notice: 'Like was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /likes/1
  def destroy
    @like.destroy
    message = "Like was successfully deleted."
    if Rails.application.routes.recognize_path(request.referrer)[:controller] != Rails.application.routes.recognize_path(request.path)[:controller]
      redirect_back fallback_location: request.referrer, notice: message
    else
      redirect_to likes_url, notice: message
    end
  end


  private

  def current_user_must_be_like_user
    set_like
    unless current_user == @like.user
      redirect_back fallback_location: root_path, alert: "You are not authorized for that."
    end
  end

    # Use callbacks to share common setup or constraints between actions.
    def set_like
      @like = Like.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def like_params
      params.require(:like).permit(:user_id, :photo_id)
    end
end
