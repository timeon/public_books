class MediaController < ApplicationController
  load_and_authorize_resource
  before_action :set_medium, only: [:show, :edit, :update, :destroy]

  respond_to :html, :json, :xml

  def index
    @media = Medium.paginate(:page => params[:page], :per_page => params[:per_page])
    respond_with(@media)
  end

  def show
    respond_with(@medium)
  end

  def new
    @medium = Medium.new
    respond_with(@medium)
  end

  def edit
  end

  def create
    @medium = Medium.new(medium_params)
    flash[:notice] = 'Medium was successfully created.' if @medium.save
    respond_with(@medium)
  end

  def update
    flash[:notice] = 'Medium was successfully updated.' if @medium.update(medium_params)
    respond_with(@medium)
  end

  def destroy
    @medium.destroy
    respond_with(@medium)
  end

  private
    def set_medium
      @medium = Medium.find(params[:id])
    end

    def medium_params
      params.require(:medium).permit(:name, :icon)
    end
end
