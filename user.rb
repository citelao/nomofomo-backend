class User
    def initialize(id, name, picture)
        @user_id=id
        @name=name
        @picture=picture
    end
    def to_json
        {'user_id' => @user_id, 'name' => @name, 'picture' => @picture}.to_json
    end
end