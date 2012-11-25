require 'rubygems'
require 'sinatra'
require 'data_mapper'
require 'sinatra/reloader'
require 'twilio-ruby'
require 'dm-postgres-adapter'
require 'time'
require 'debugger'
require './twilio_wrapper'
require './message'

DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, ENV['DATABASE_URL'])
DataMapper.finalize
DataMapper.auto_migrate!


get '/' do
  Message.save_inbound_messages
  @messages = Message.all
  erb :index
end

get '/update_messages' do
  # resave messages from twilio
  Message.save_inbound_messages
  # check for new messages since last updated time
  latest_timestamp = Time.parse(params[:latest_timestamp]).to_datetime
  @messages = Message.all.select { |message| message.date_created > latest_timestamp }
  erb :message
end

get '/admin' do
  @messages = Message.all
  erb :admin
end

