class RestaurantsController < ApplicationController

	#SHOW all restaurants
	def index
		@restaurants = Restaurant.all
		@cuisine_types = CuisineType.all.order('name ASC')
	end

	#SHOW create new restaurant page; admin only
	def new
		if current_user.admin? 
			@restaurant = Restaurant.new
			@cuisine_types = CuisineType.all
		else
			redirect_to new_user_session_path
		end
	end

	#CREATE new restaurant
	def create
		@restaurant = Restaurant.new
		@restaurant.update_with_foursquare(sanitized_restaurant_params)
		CuisineType.all.each do |type|
			if params[:cuisine_type_ids] == nil || !params[:cuisine_type_ids].include?(type.id.to_s)
				@restaurant.cuisine_types.delete(CuisineType.find(type.id)) if @restaurant.cuisine_types.where(id: type.id).exists?	
			else
				@restaurant.cuisine_types << CuisineType.find(type.id) if !@restaurant.cuisine_types.where(id: type.id).exists?
			end
		end
		redirect_to root_path
	end

	#SHOW one restaurant
	def show
		@restaurant = Restaurant.find(params[:id])
		if current_user
			@reservations = @restaurant.reservations.where("user_id = #{current_user.id}")
			if current_user.restaurant_id == @restaurant.id || current_user.admin?
				@reservations = @restaurant.reservations
			end
		else
			@reservations = nil
		end
	end

	#EDIT one restaurant; admins and restaurant owners only
	def edit
		if current_user && (current_user.admin? || current_user.restaurant_id = params[:id])
			@restaurant = Restaurant.find(params[:id])
			@cuisine_types = CuisineType.all
		else
			redirect_to new_user_session_path
		end
	end

	#UPDATE restaurant; check all cuisine types for changes
	def update
		@restaurant = Restaurant.find(params[:id])
		@restaurant.update_with_foursquare(sanitized_restaurant_params)
		CuisineType.all.each do |type|
			if params[:cuisine_type_ids] == nil || !params[:cuisine_type_ids].include?(type.id.to_s)
				@restaurant.cuisine_types.delete(CuisineType.find(type.id)) if @restaurant.cuisine_types.where(id: type.id).exists?	
			else
				@restaurant.cuisine_types << CuisineType.find(type.id) if !@restaurant.cuisine_types.where(id: type.id).exists?
			end
		end
		redirect_to restaurant_path(@restaurant)
	end

	#Cleaning input parameters
	private 
	def sanitized_restaurant_params
		params.require(:restaurant).permit(:name, :capacity, :foursquare_id)
	end

end