# myapp.rb
require 'sinatra'

get '/hello' do
  'Hello world!'
end

get '/goodbye' do
  'Goodbye world!'
end
