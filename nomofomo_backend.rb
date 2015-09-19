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

get '/users/:user_id/interested' do
	#returns interested events for user
	"interested events for #{params['user_id']}"
end

get '/users/:user_id/created' do
	#returns events created by user
	"events created by #{params['user_id']}"
end

get '/users/:user_id/rejected' do
	# returns events rejected by user
	"events rejected by #{params['user_id']}"
end

get '/users/:user_id/confirmed' do
	#returns events confirmed by user
	"events confirmed by #{params['user_id']}"
end

get '/users/:user_id' do
	# input: userId as http param under id
	# output: name, pic, created events, interested events, confirmed events, rejected events
	"user for #{params['user_id']}"
end

post '/users' do #?id=12345&picture=xxxx.jpg&name=Xxx Xxx
	# create a user with given id, pic, name
	"create a user with id #{params['id']}, picture #{params['picture']}, name #{params['name']}"
end

post '/events/:event_id/interested/:user_id' do
	"user #{params['user_id']} is interested in event #{params['event_id']}"
end

post '/events/:event_id/rejected/:user_id' do
	"user #{params['user_id']} rejected event #{params['event_id']}"
end

post '/events/:event_id/confirmed/:user_id' do
	"user #{params['user_id']} confirmed event #{params['event_id']}"
end

delete '/events/:event_id/interested/:user_id' do
	"user #{params['user_id']} is not interested in event #{params['event_id']}"
end

delete '/events/:event_id/rejected/:user_id' do
	"user #{params['user_id']} did not reject event #{params['event_id']}"
end

delete '/events/:event_id/confirmed/:user_id' do
	"user #{params['user_id']} did not confirm event #{params['event_id']}"
end

get '/events/:event_id' do
  "event for id #{params['event_id']}!"
end

post '/events' do 
	# ?creator_id=12345&name=event name&description=event description&lat=30.0&lng=100.0&loc=4 main st
	# start_time=1442689962&duration=3600&picture=asdf.jpg&metadata=...
	# start_time is in seconds since the epoch; duration is in seconds; loc is a string description of location
	# metadata is anything
	"create an event by user: #{params['creator_id']}, name: #{params['name']}, description: #{params['description']}
	lat: #{params['lat']}, lng: #{params['lng']}, location: #{params['loc']}, start_time: #{params['start_time']}
	duration: #{params['duration']}, picture: #{params['picture']}"
end

get '/events' do
	# exclude rejected, confirmed, interested, created
	# output: all other events ordered by magic or location
	"all events"
end

