require 'sinatra'
require 'data_mapper'
require 'sinatra/reloader'
require 'twilio-ruby'
# require './credentials'

DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, 'sqlite::memory:')

get '/' do
  erb :index
end

class Message
  include DataMapper::Resource

  property :id,           Serial
  property :content,      String
  property :number,       String
  property :date_created, DateTime
  property :created_at,   DateTime
  validates_uniqueness_of :content

  def self.save_inbound_messages
    messages = TwilioWrapper.new.inbound_messages
    messages.each {|message| { create content: message.body, number: message.from, date_created: message.date_created }
  end
end

class TwilioWrapper
  attr_reader :client

  def initialize
    @client = Twilio::REST::Client.new $account_sid, $auth_token
  end

  def inbound_messages
    messages = client.account.sms.messages.list.select do |sms|
      sms.direction == 'inbound'
    end
  end

  def send_sms(to)
    client.account.sms.messages.create(
      :from => '+14088004336',
      :to => to,
      :body => "Thanks for your text")
  end
end