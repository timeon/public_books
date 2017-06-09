class FormatsController < ApplicationController
  load_and_authorize_resource
  before_action :set_format, only: [:show, :edit, :update, :destroy]

  respond_to :html, :json, :xml

  def index
    @formats = Format.paginate(:page => params[:page], :per_page => params[:per_page])
    respond_with(@formats)
  end

  def show
    respond_with(@format)
  end

  def new
    @format = Format.new
    respond_with(@format)
  end

  def edit
  end

  def create
    @format = Format.new(format_params)
    flash[:notice] = 'Format was successfully created.' if @format.save
    respond_with(@format)
  end

  def update
    flash[:notice] = 'Format was successfully updated.' if @format.update(format_params)
    respond_with(@format)
  end

  def destroy
    @format.destroy
    respond_with(@format)
  end

  private
    def set_format
      @format = Format.find(params[:id])
    end

    def format_params
      params.require(:format).permit(:name)
    end
end
