class PropertiesController < ApplicationController
  before_action :set_property, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :edit, :create, :update, :destroy]
  def index  #To render page showing ALL properties
    @properties = Property.all
    @prop_desc_price = Property.order('price DESC')
    @prop_asc_price = Property.order('price')
    @prop_recent = Property.order('created_at DESC')
    @prop_popular = (@properties.sort_by {|prop| prop.shortlists.count}).reverse!

  end

  def show  #To render page of select property
    #No need anything here, because before_action executed with set_property @property and auto route to /show page
  end

  def new  #To render page where you can create property
    @property = Property.new
    #RAILS AUTOMATICALLY renders view in properties/new!
    @amenities = Amenity.all
  end

  def create  #To do post request to create property
    @property = Property.new(property_params)
    # @property.amenities.push(#capture form id1)

    respond_to do |format|
      if @property.save
      format.html {redirect_to @property, notice: 'Property was successfully listed.'}
      format.json {render :show, status: :created, location: @property}
      else
      format.html {render :new}
      format.json {render json: @property.errors, status: :unprocessable_entity}
      end
    end

  end


  def edit  #To render page where you can edit property
#No need anything here, because before_action executed with set_property @property and auto route to /edit page

  end

  def update #To do put request to edit property

    respond_to do |format|
      if @property.update(property_params)
      format.html {redirect_to @property, notice: 'Property listing was updated successfully.'}
      format.json {render :show, status: :created, location: @property}
      else
      format.html {render :edit}
      format.json {render json: @property.errors, status: :unprocessable_entity}
      end
    end
  end

  def destroy  #To delete listed property
    @property.destroy
    @listings = current_user.properties
    @properties = Property.all
    respond_to do |format|
      format.html { render :listings, notice: 'Property was successfully de-listed.' }
      format.json { head :no_content }
    end
  end

  def listings
    @listings = current_user.properties
    @properties = Property.all
  end

  private

  def set_property
    @property = Property.find(params[:id])

  end

  def property_params
    params.require(:property).permit(:address, :postcode, :price, :description, :lease_durn, :property_type, :rent_area, :photo_url, :amenity_ids =>[])
  end

end
