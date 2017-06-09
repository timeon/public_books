class PeopleController < ApplicationController
  load_and_authorize_resource
  before_action :set_person, only: [:show, :edit, :update, :destroy]

  respond_to :html, :json, :xml

  def index
    @people = Person.paginate(:page => params[:page], :per_page => params[:per_page])
    respond_with(@people)
  end

  def show
    respond_with(@person)
  end

  def new
    @person = Person.new
    respond_with(@person)
  end

  def edit
  end

  def create
    @person = Person.new(person_params)
    flash[:notice] = 'Person was successfully created.' if @person.save
    respond_with(@person)
  end

  def update
    flash[:notice] = 'Person was successfully updated.' if @person.update(person_params)
    respond_with(@person)
  end

  def destroy
    @person.destroy
    respond_with(@person)
  end
  alias_method :delete, :destroy

  private
    def set_person
      @person = Person.find(params[:id])
    end

    def person_params
      params.require(:person).permit(:family_id, :relation, :first_name, :last_name, :chinese_name, :email, :phone, :phone_ext)
    end
end
