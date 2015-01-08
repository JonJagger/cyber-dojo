class TrafficLightsController < ApplicationController
  before_action :set_traffic_light, only: [:show, :edit, :update, :destroy]

  # GET /traffic_lights
  def index
    @traffic_lights = TrafficLight.all
  end

  # GET /traffic_lights/1
  def show
  end

  # GET /traffic_lights/new
  def new
    @traffic_light = TrafficLight.new
  end

  # GET /traffic_lights/1/edit
  def edit
  end

  # POST /traffic_lights
  def create
    @traffic_light = TrafficLight.new(traffic_light_params)

    if @traffic_light.save
      redirect_to @traffic_light, notice: 'Traffic light was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /traffic_lights/1
  def update
    if @traffic_light.update(traffic_light_params)
      redirect_to @traffic_light, notice: 'Traffic light was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /traffic_lights/1
  def destroy
    @traffic_light.destroy
    redirect_to traffic_lights_url, notice: 'Traffic light was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_traffic_light
      @traffic_light = TrafficLight.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def traffic_light_params
      params.require(:traffic_light).permit(:tag, :content_hash, :fork_count, :AvatarSession_id)
    end
end
