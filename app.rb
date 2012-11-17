require 'sinatra'
require 'sinatra/reloader'
require 'twilio-ruby'
require './credentials'

get '/' do
  erb :index
end

class Message
end

class TwilioWrapper
  attr_reader :client

  def initialize
    @client = Twilio::REST::Client.new $account_sid, $auth_token
  end

  def send_sms(to)
    @client.account.sms.messages.create(
      :from => '+14088004336',
      :to => to,
      :body => "Thanks for your text")
  end

  
end

twilio = TwilioWrapper.new
puts twilio.client.inspect