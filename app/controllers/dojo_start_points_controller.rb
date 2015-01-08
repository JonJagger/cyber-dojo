class DojoStartPointsController < ApplicationController
  before_action :set_dojo_start_point, only: [:show, :edit, :update, :destroy]

  # GET /dojo_start_points
  def index
    @dojo_start_points = DojoStartPoint.all
  end

  # GET /dojo_start_points/1
  def show
  end

  # GET /dojo_start_points/new
  def new
    @dojo_start_point = DojoStartPoint.new
  end

  # GET /dojo_start_points/1/edit
  def edit
  end

  # POST /dojo_start_points
  def create
    @dojo_start_point = DojoStartPoint.new(dojo_start_point_params)

    if @dojo_start_point.save
      redirect_to @dojo_start_point, notice: 'Dojo start point was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /dojo_start_points/1
  def update
    if @dojo_start_point.update(dojo_start_point_params)
      redirect_to @dojo_start_point, notice: 'Dojo start point was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /dojo_start_points/1
  def destroy
    @dojo_start_point.destroy
    redirect_to dojo_start_points_url, notice: 'Dojo start point was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dojo_start_point
      @dojo_start_point = DojoStartPoint.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def dojo_start_point_params
      params.require(:dojo_start_point).permit(:dojo_id, :language, :exercise)
    end
end
