class Restaurant < ActiveRecord::Base
	has_and_belongs_to_many :cuisine_types
	has_many :restaurants
	has_many :reservations
	has_many :users

	validates :foursquare_id, :capacity, presence: true


	def update_with_foursquare (restaurant_params)
		httpbot = HTTPClient.new
		http = httpbot.get("https://api.foursquare.com/v2/venues/#{restaurant_params[:foursquare_id]}?client_id=JKIGWG2CJUOHAJ1BHL11YFIGVD3MLQW2WGNEK35EZLWAWHGM
&client_secret=ZNW4OWFODXJ50MBN1SPEKUODXMKWCH5DIWBCM3RMXNXYOCBS&v=20140806")
		data = JSON.parse(http.content)
		restaurant_params_with_4sq = {
			name: data["response"]["venue"]["name"],
			capacity: restaurant_params[:capacity],
			foursquare_id: restaurant_params[:foursquare_id],
			address_1: data["response"]["venue"]["location"]["address"],
			city: data["response"]["venue"]["location"]["city"],
			province: data["response"]["venue"]["location"]["state"],
			photo: data["response"]["venue"]["photos"]["groups"][0]["items"][0]["prefix"] + "240x240" + data["response"]["venue"]["photos"]["groups"][0]["items"][0]["suffix"]
		}
		self.update(restaurant_params_with_4sq)
	end

end


