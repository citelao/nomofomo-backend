class User
    def initialize(id, name, picture)
        @user_id=id
        @name=name
        @picture=picture
        @created_event_ids=[]
        @interested_event_ids=[]
        @confirmed_event_ids=[]
        @disliked_event_ids=[]
    end
    def to_json
        {'user_id' => @user_id, 'name' => @name, 'picture' => @picture}.to_json
    end
    def setCreated(event_id)
    	@created_event_ids.push(event_id)
    end
    def setInterested(event_id)
    	@interested_event_ids.push(event_id)
    end
    def setConfirmed(event_id)
    	@confirmed_event_ids.push(event_id)
    end
    def setDisliked(event_id)
    	@disliked_event_ids.push(event_id)
    end
end