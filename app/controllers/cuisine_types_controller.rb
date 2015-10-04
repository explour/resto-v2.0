class CuisineTypesController < ApplicationController

	#POST - create new cuisine type / no unique page
	def create
		@cuisine_type = CuisineType.create(sanitized_cuisine_params)
		redirect_to root_path
	end

	#SHOW INDEX of all restaurants with that CuisineType
	def show
		@cuisine_type = CuisineType.find_by_id(params[:id])
		@cuisine_types = CuisineType.all.order('name ASC')
		@restaurants = @cuisine_type.restaurants
		@restaurant = Restaurant.new
	end

	
	private
	def sanitized_cuisine_params
		params.permit(:name)
	end

end
