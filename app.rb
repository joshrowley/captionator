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

helpers do

  def protected!
    unless authorized?
      response['WWW-Authenticate'] = %(Basic realm="Restricted Area")
      throw(:halt, [401, "Not authorized\n"])
    end
  end

  def authorized?
    @auth ||=  Rack::Auth::Basic::Request.new(request.env)
    @auth.provided? && @auth.basic? && @auth.credentials && @auth.credentials == [ ENV['ZARA_USER'], ENV['ZARA_PASSWORD']]
  end

end

get '/' do
  Message.save_inbound_messages
  @messages = Message.all(:deleted => false)
  erb :index
end

get '/update_messages' do
  # resave messages from twilio
  Message.save_inbound_messages
  # check for new messages since last updated time
  latest_timestamp = Time.parse(params[:latest_timestamp]).to_datetime if params[:latest_timestamp]
  @messages = Message.all.select { |message| message.date_created > latest_timestamp }
  erb :message
end

get '/admin' do
  protected!
  @messages = Message.all(:deleted => false)
  @deleted_messages = Message.all(:deleted => true)
  erb :admin
end

get '/delete_message/:id' do
  protected!
  Message.get(params[:id]).update(:deleted => true)
  redirect '/admin'
end

get '/restore_message/:id' do
  protected!
  Message.get(params[:id]).update(:deleted => false)
  redirect '/admin'
end

get '/reset_messages' do
  protected!
  Message.all.each do |message|
    message.update(:deleted => true)
  end
  redirect '/admin'
end