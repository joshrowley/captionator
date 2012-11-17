require 'sinatra'
require 'data_mapper'
require 'sinatra/reloader'
require 'twilio-ruby'
require 'dm-sqlite-adapter'
require './credentials'
require './twilio_wrapper'
require './message'
require 'debugger'

DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, 'sqlite::memory:')
DataMapper.finalize
DataMapper.auto_migrate!




get '/' do
  Message.save_inbound_messages
  @messages = Message.all
  erb :index
end



