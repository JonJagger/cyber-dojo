class AvatarSessionsController < ApplicationController
  before_action :set_avatar_session, only: [:show, :edit, :update, :destroy]

  # GET /avatar_sessions
  def index
    @avatar_sessions = AvatarSession.all
  end

  # GET /avatar_sessions/1
  def show
  end

  # GET /avatar_sessions/new
  def new
    @avatar_session = AvatarSession.new
  end

  # GET /avatar_sessions/1/edit
  def edit
  end

  # POST /avatar_sessions
  def create
    @avatar_session = AvatarSession.new(avatar_session_params)

    if @avatar_session.save
      redirect_to @avatar_session, notice: 'Avatar session was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /avatar_sessions/1
  def update
    if @avatar_session.update(avatar_session_params)
      redirect_to @avatar_session, notice: 'Avatar session was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /avatar_sessions/1
  def destroy
    @avatar_session.destroy
    redirect_to avatar_sessions_url, notice: 'Avatar session was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_avatar_session
      @avatar_session = AvatarSession.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def avatar_session_params
      params.require(:avatar_session).permit(:avatar, :vote_count, :fork_count, :dojo_start_point_id)
    end
end
