require 'sinatra'
require 'sinatra/cross_origin'

configure do
  enable :cross_origin
end

set :allow_origin, :any
set :allow_methods, [:get, :post, :options]
set :allow_credentials, true
set :max_age, "1728000"
set :expose_headers, ['Content-Type']

options "*" do
  response.headers["Allow"] = "HEAD,GET,PUT,POST,DELETE,OPTIONS"
  response.headers["Access-Control-Allow-Headers"] = "X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept"
  200
end

# map of userid -> user
users = {}

# map of eventid -> event
events = {}

# map from hashed fb id -> array of their created event ids
user_created_events = {}

# map from hashed fb id -> array of their interested (right swiped) event ids
user_interested_events = {}

# map from hashed fb id -> array of their left swiped (dismissed) event ids
user_disliked_events = {}

# map from hashed fb id -> array of their confirmed event ids
user_confirmed_events = {}

class User
   def initialize(id, name, picture)
      @user_id=id
      @name=name
      @picture=picture
   end
end

class Event
	def initialize(creator, name, description, lat, lng, start_time, 
		duration, picture, metadata, interested_users, confirmed_users)
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
end

get '/hello' do
  url = params[:url]
  "Hello #{params}!"
end
