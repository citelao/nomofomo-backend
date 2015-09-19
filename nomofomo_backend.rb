require 'sinatra'
require 'sinatra/cross_origin'
require 'json'
require './user'
require './event'

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
events = Event.fake_events

# map from hashed fb id -> array of their created event ids
user_created_events = {}

# map from hashed fb id -> array of their interested (right swiped) event ids
user_interested_events = {}

# map from hashed fb id -> array of their left swiped (dismissed) event ids
user_disliked_events = {}

# map from hashed fb id -> array of their confirmed event ids
user_confirmed_events = {}

get '/hello' do
  url = params[:url]
  "Hello #{params}!"
end

#returns interested events for user
get '/users/:user_id/interested' do
	user_interested_events[Integer(params['user_id'])]
end

#returns events created by user
get '/users/:user_id/created' do
	user_created_events[Integer(params['user_id'])]
end

# returns events rejected by user
get '/users/:user_id/rejected' do
	user_disliked_events[Integer(params['user_id'])]
end

#returns events confirmed by user
get '/users/:user_id/confirmed' do
	user_confirmed_events[Integer(params['user_id'])]
end

# input: userId as http param under id
# output: name, pic, created events, interested events, confirmed events, rejected events
# TODO make sure to update their created, interested, confirmed, rejected upon create/interested/confirm/reject
get '/users/:user_id' do
	users[Integer(params['user_id'])]
end

# create a user with given id, pic, name
post '/users' do #?id=12345&picture=xxxx.jpg&name=Xxx Xxx
	users[params['id']] = User.new(params['id'], params['name'], params['picture'])
	"created a user: #{users[params['id']].to_json}"
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
    events[Integer(params['event_id'])].to_json
end

# start_time is in seconds since the epoch; duration is in seconds; loc is a string description of location
# metadata is anything
post '/events' do 
	# ?creator_id=12345&name=event name&description=event description&lat=30.0&lng=100.0&loc=4 main st
	# start_time=1442689962&duration=3600&picture=asdf.jpg&metadata=...
	if events.size == 0
		id = 1
	else
		id = events.keys.max + 1
	end
	events[id] = Event.new(id, params['creator_id'], params['name'], params['description'], params['lat'], 
		params['lng'], params['loc'], params['start_time'], params['duration'], params['picture'], params['metadata'], [], [])
	"created event: #{events[id].to_json}"
end

# exclude rejected, confirmed, interested, created
# output: all other events ordered by magic or location
get '/events' do
	"all events"
end

