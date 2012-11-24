require 'rubygems'
require 'sinatra'
require 'data_mapper'
require 'sinatra/reloader'
require 'twilio-ruby'
require 'dm-postgres-adapter'
require './credentials'
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



