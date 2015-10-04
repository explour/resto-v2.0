class ReservationsController < ApplicationController

	#CREATE NEW RESERVATION
	def new
		@restaurant = Restaurant.find(params[:restaurant_id])
		@reservation = Reservation.new({restaurant_id: params[:restaurant_id]})
	end

	def create
		if current_user
			@reservation = Reservation.new(sanitized_reservations_params)
			@reservation.restaurant_id = params[:restaurant_id]
			@reservation.user_id = current_user.id
			@reservation.save
			redirect_to restaurant_path(params[:restaurant_id])
		else
			redirect_to new_user_session_path
		end
	end

	private
	def sanitized_reservations_params
		params.require(:reservation).permit(:party_size, :time)
	end

end