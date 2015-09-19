class User
    def initialize(id, name, picture)
        @user_id=id
        @name=name
        @picture=picture
        @created_event_ids=[]
        @interested_event_ids=[]
        @confirmed_event_ids=[]
        @rejected_event_ids=[]
    end

    def to_json
        {'user_id' => @user_id, 'name' => @name, 'picture' => @picture}.to_json
    end
    
    def set_created(event_id)
    	@created_event_ids.push(event_id)
    end
    
    def set_interested(event_id)
    	@interested_event_ids.push(event_id)
    end
    
    def set_confirmed(event_id)
    	@confirmed_event_ids.push(event_id)
    end

    def set_rejected(event_id)
    	@rejected_event_ids.push(event_id)
    end

    def remove_interested_event(event_id)
    	@interested_event_ids.remove(event_id)
    end

    def remove_rejected_event(event_id)
    	@rejected_event_ids.remove(event_id)
    end

    def remove_confirmed_event(event_id)
    	@confirmed_event_ids.remove(event_id)
    end

    def self.fake_users()
    	{
    		1 => User.new(1, "Ellen", "https://scontent-iad3-1.xx.fbcdn.net/hphotos-xfa1/v/t1.0-9/11737911_10207192721445112_2262968242331077686_n.jpg?oh=e161bf151297ffc86ee4bcd696862687&oe=569F2100"),
    		2 => User.new(1, "Ben", "https://scontent-iad3-1.xx.fbcdn.net/hprofile-xap1/v/t1.0-1/p160x160/11052452_10152841580675981_2927252468945499141_n.jpg?oh=ae2915945c39a03e72d4549c83e33e0f&oe=5668D0A1"),
    		3 => User.new(1, "Estella", "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xlf1/v/t1.0-1/p160x160/11953161_947949938626009_879800015357192067_n.jpg?oh=0a62d4a9c3abb760be00df7e1bd25c89&oe=56972964&__gda__=1453035558_879e32269ed4b9505ad98040e091a64d"),
    	}
    end
end