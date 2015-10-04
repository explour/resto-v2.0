class Reservation < ActiveRecord::Base
	belongs_to :user
	belongs_to :restaurant
	validates :user_id, :time, :party_size, :restaurant_id, presence: true

	validate :restaurant_must_have_capacity
	def restaurant_must_have_capacity
		@existing_reservations = self.restaurant.reservations.where('time > ? AND time < ?', self.time - 1.hour, self.time + 1.hour)
		if self.party_size + @existing_reservations.sum('party_size') > self.restaurant.capacity
			errors.add(:party_size, "Restaurant is over capacity.")
		end
	end

end
