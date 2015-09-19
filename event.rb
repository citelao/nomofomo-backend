require 'date'

class Event
	def initialize(id, creator, name, description, lat, lng, location, start_time, duration,
		picture, metadata, interested_users, confirmed_users)
		@id=id
		@creator=creator
		@name=name
		@description=description
		@lat=lat
		@lng=lng
		@location=location
		@start_time=start_time
		@duration=duration
		@picture=picture
		@metadata=metadata
		@interested_users=interested_users
		@confirmed_users=confirmed_users
	end
	
	def to_json
        {'id' => @id, 'creator' => @creator, 'name' => @name, 'description' => @description,
        	'lat' => @lat, 'lng' => @lng, 'start_time' => @start_time, 'duration' => @duration,'picture' => @picture,
        	'metadata' => @metadata, 'interested_users' => @interested_users,'confirmed_users' => @confirmed_users}.to_json
    end

    def self.fake_events
    	# TODO, change the users 1 and 2 to real FB ids for real people
    	{
    		1 => Event.new(1, 1, "Grab dinner at @ Pita Factory", "this place looks awesome", 43.471856, -80.538886,
    			"170 University Avenue W Waterloo, ON N2L 3E9 Canada",
    			DateTime.now.to_time.to_i + 60 * 60, 60 * 60, "img", "", [1], [1]),
    		2 => Event.new(2, 2, "study group @ EC5", "Let's meet up and study tonight :)", 43.472974, -80.540043,
    			"200 University Ave W Waterloo, ON N2L 3E9 Canada",
    			DateTime.now.to_time.to_i, 60 * 60 * 4, "http://i.imgur.com/8LLjKh8.jpg","",[1,2],[1,2])
    	}
    end
end
