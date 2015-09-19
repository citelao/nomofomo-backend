# myapp.rb
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

# map from event id -> [name, minAttendance, hostUserId, yelpid]
events = {1 => ["dinner @ the Lockhart", 3, 5, 13246]}

# map from hashed fb id -> array of their favorited event ids
user_favorites = {}

# map from hashed fb id -> array of their left swiped (dismissed) event ids
user_left_swipes = {}

# map from hashed fb id -> array of their confirmed event ids
user_confirmed_events = {}


get '/hello/:name' do
  # matches "GET /hello/foo" and "GET /hello/bar"
  # params['name'] is 'foo' or 'bar'
  "Hello #{params['name']}!"
end


