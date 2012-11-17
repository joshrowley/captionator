require 'sinatra'
require 'sinatra/reloader'

get '/' do
  erb :index
end

class Message
end

class Twilio
end