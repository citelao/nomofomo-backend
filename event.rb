class Event
	def initialize(creator, name, description, lat, lng, start_time, duration, picture, metadata, interested_users, confirmed_users)
		@creator=creator
		@name=name
		@description=description
		@lat=lat
		@lng=lng
		@start_time=start_time
		@duration=duration
		@picture=picture
		@metadata=metadata
		@interested_users=interested_users
		@confirmed_users=confirmed_users
	end
	def to_json
        {'creator' => @creator, 'name' => @name, 'description' => @description,'lat' => @lat, 'lng' => @lng, 'start_time' => @start_time, 'duration' => @duration,'picture' => @picture, 'metadata' => @metadata, 'interested_users' => @interested_users,'confirmed_users' => @confirmed_users}.to_json
    end
end
