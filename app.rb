require 'sinatra'
require 'sinatra/reloader'
require 'twilio-ruby'

get '/' do
  erb :index
end

class Message
end

class Twilio
end