require 'date'

class Event
	def initialize(id, creator, name, description, lat, lng, location, start_time, duration,
		picture, min_attendance, metadata, interested_users, confirmed_users, rejected_users)
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
		@min_attendance=min_attendance
		@metadata=metadata
		@interested_users=interested_users
		@confirmed_users=confirmed_users
		@rejected_users=rejected_users
	end

	def to_json
        {'id' => @id, 'creator' => @creator, 'name' => @name, 'description' => @description,
        	'lat' => @lat, 'lng' => @lng, 'address' => @location, 'start_time' => @start_time, 'duration' => @duration, 'picture' => @picture,
        	'min_attendance' => @min_attendance, 'metadata' => @metadata, 'interested_users' => @interested_users, 
        	'confirmed_users' => @confirmed_users, 'rejected_users' => @rejected_users}.to_json
    end

    def add_interested_user(user_id)
    	@interested_users.push(user_id)
    end

    def add_confirmed_user(user_id)
    	@confirmed_users.push(user_id)
    end

    def add_rejected_user(user_id)
    	@rejected_users.push(user_id)
    end

    def remove_interested_user(user_id)
    	@interested_users.delete(user_id)
    end

    def remove_confirmed_user(user_id)
    	@confirmed_users.delete(user_id)
    end

    def remove_rejected_user(user_id)
    	@rejected_users.delete(user_id)
    end

    def is_creator(user_id)
    	user_id == @creator
	end

	def is_interested(user_id)
    	@interested_users.include? user_id
	end

	def is_rejected(user_id)
    	@rejected_users.include? user_id
	end

	def is_confirmed(user_id)
    	@confirmed_users.include? user_id
	end

    def self.fake_events
    	description_text = "Lorem ipsum dolor sit amet, vero mazim vis ne, per option disputando no. In vim stet simul dicunt. Ei eos perpetua philosophia, est id agam eros iuvaret, vide placerat ne mei. Propriae disputando duo no. Per et doctus tibique prodesset."
    	# TODO, change the users 1 and 2 to real FB ids for real people
    	{
    		1 => Event.new(1, 1, "Grab dinner at @ Pita Factory", description_text, 43.471856, -80.538886,
    			"170 University Avenue W Waterloo, ON N2L 3E9 Canada",
    			DateTime.now.to_time.to_i + 60 * 60, 60 * 60, "http://365-kw.com/wp-content/uploads/2010/10/Picture23-1.png", 2, "", [1], [], []),
    		2 => Event.new(2, 2, "study group @ EC5", description_text, 43.472974, -80.540043,
    			"200 University Ave W Waterloo, ON N2L 3E9 Canada",
    			DateTime.now.to_time.to_i, 60 * 60 * 4, "http://i.imgur.com/8LLjKh8.jpg", 3, "", [2], [], []),
    		3 => Event.new(3, 3, "Movie tonight", description_text, 43.466914, -80.523434,
    			"6 Princess St W Waterloo, ON N2L 2X8 Canada",
    			DateTime.now.to_time.to_i + 2 * 60 * 60, 3, "http://www.thecord.ca/wp-content/uploads/2012/09/Princess-MeganCherniak-colour.jpg", 2, "", [3], [], []),
    		4 => Event.new(4, 2, "Coffee & chat?", description_text, 43.471361, -80.534711,
    			"108 Seagram Dr Waterloo, ON N2L 3G1 Canada",
    			DateTime.now.to_time.to_i + 2 * 60 * 60, 3, "https://upload.wikimedia.org/wikipedia/commons/9/91/Tim_Hortons_US_Logo.jpg", 2, "", [2], [], []),
     		5 => Event.new(5, 3, "Rock climbing!", description_text, 43.441376, -80.475130,
    			"50 Borden Ave S #1, Kitchener, ON N2G 3R5, Canada",
    			DateTime.now.to_time.to_i + 3 * 60 * 60, 3, "https://wisconsinbeerrunner.files.wordpress.com/2011/04/img_0114.jpg", 2, "", [3], [], []),
    		6 => Event.new(6, 1, "Grab a Greek for lunch", description_text, 43.471836, -80.538897,
				"170 University Avenue W Waterloo, ON N2L 3E9 Canada",
    			DateTime.now.to_time.to_i + 30 * 60, 3, "http://watcard.uwaterloo.ca/images/logos/grabagreek.jpg", 2, "", [1], [], []),
    		7 => Event.new(7, 3, "Let's go on a hike", description_text, 43.456395, -80.406017,
    			"Breslau, ON N0B 1M0 Canada",
    			DateTime.now.to_time.to_i + 3.2 * 60 * 60, 3, "http://www.torontohiking.com/tohi/images/articles/mainhw/L25H_IMG_4053.jpg", 2, "", [3], [], [])
    	}
    end
end
