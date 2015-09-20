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
  response.headers["Access-Control-Allow-Headers"] =
  "X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept"
  200
end

# map of userid -> user
users = User.fake_users

# map of eventid -> event
events = Event.fake_events

get '/hello' do
  url = params[:url]
  "Hello #{params}!"
end

#returns interested events for user
get '/users/:user_id/interested' do
	users[Integer(params['user_id'])].interested_event_ids.uniq.to_json
end

#returns events created by user
get '/users/:user_id/created' do
	users[Integer(params['user_id'])].created_event_ids.uniq.to_json
end

# returns events rejected by user
get '/users/:user_id/rejected' do
	users[Integer(params['user_id'])].rejected_event_ids.uniq.to_json
end

#returns events confirmed by user
get '/users/:user_id/confirmed' do
	users[Integer(params['user_id'])].confirmed_event_ids.uniq.to_json
end

# input: userId as http param under id
# output: name, pic, created events, interested events, confirmed events, rejected events
get '/users/:user_id' do
	users[Integer(params['user_id'])]
end

# create a user with given id, pic, name
post '/users' do #?id=12345&picture=xxxx.jpg&name=Xxx Xxx
	users[Integer(params['id'])] = User.new(params['id'], params['name'], params['picture'])
	"created a user: #{users[params['id']].to_json}"
end

post '/events/:event_id/interested/:user_id' do
	user_id = Integer(params['user_id'])
	event_id = Integer(params['event_id'])
	users[user_id].set_interested(event_id)
	events[event_id].add_interested_user(user_id)
	"user #{params['user_id']} is interested in event #{params['event_id']}"
end

post '/events/:event_id/rejected/:user_id' do
	user_id = Integer(params['user_id'])
	event_id = Integer(params['event_id'])
	users[user_id].set_rejected(event_id)
	events[event_id].add_rejected_user(user_id)
	"user #{params['user_id']} rejected event #{params['event_id']}"
end

post '/events/:event_id/confirmed/:user_id' do
	user_id = Integer(params['user_id'])
	event_id = Integer(params['event_id'])
	users[user_id].set_confirmed(event_id)
	events[event_id].add_confirmed_user(user_id)
	events[event_id].remove_interested_user(user_id)
	# TODO remove them as an interested user in the event
	"user #{params['user_id']} confirmed event #{params['event_id']}"
end

delete '/events/:event_id/interested/:user_id' do
	user_id = Integer(params['user_id'])
	event_id = Integer(params['event_id'])
	events[event_id].remove_interested_user(user_id)
	users[user_id].remove_interested_event(event_id)
	"user #{params['user_id']} is not interested in event #{params['event_id']}"
end

delete '/events/:event_id/rejected/:user_id' do
	user_id = Integer(params['user_id'])
	event_id = Integer(params['event_id'])
	users[user_id].remove_rejected_event(event_id)
	"user #{params['user_id']} did not reject event #{params['event_id']}"
end

delete '/events/:event_id/confirmed/:user_id' do
	user_id = Integer(params['user_id'])
	event_id = Integer(params['event_id'])
	events[event_id].remove_confirmed_user(user_id)
	users[user_id].remove_confirmed_event(event_id)
	"user #{params['user_id']} did not confirm event #{params['event_id']}"
end

get '/events/by_id/:event_id' do
    events[Integer(params['event_id'])].to_json
end

# all events that the user should see in their feed #
# excluding rejected, interested, created and confirmed
get '/events/:user_id' do
	user_id = Integer(params['user_id'])
	result = "["
    events.values.each { |e|
    	if not e.is_creator(user_id) and not e.is_interested(user_id) and not e.is_confirmed(user_id) and not e.is_rejected(user_id)
	    	result += e.to_json + ","
	    end
    }
	if result[result.size - 1] == ","
    	result = result[0..result.size - 2]
    end
    result + "]"
end

# start_time is in seconds since the epoch; duration is in seconds;
# loc is a string description of location; metadata is anything
post '/events' do 
	# ?creator_id=12345&name=event name&description=event description&lat=30.0&lng=100.0
	# &loc=4 main st&min_attendance=3&start_time=1442689962&duration=3600&picture=asdf.jpg&metadata=...
	if events.size == 0
		id = 1
	else
		id = events.keys.max + 1
	end
	events[id] = Event.new(id, Integer(params['creator_id']), params['name'], params['description'],
		params['lat'], params['lng'], params['loc'], params['start_time'], params['duration'],
		params['picture'], params['min_attendance'], params['metadata'], [], [], [])
	users[Integer(params['creator_id'])].create_event(id)
	"created event: #{events[id].to_json}"
end

# exclude rejected, confirmed, interested, created
# output: all other events ordered by magic or location
get '/events' do
	result = "["
    events.values.each { |event|
	   result += event.to_json + ","
    }
    if result[result.size - 1] == ","
    	result = result[0..result.size - 2]
    end
    result + "]"
end

