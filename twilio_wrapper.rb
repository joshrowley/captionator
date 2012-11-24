class TwilioWrapper
  attr_reader :client

  def initialize
    @client = Twilio::REST::Client.new $account_sid, $auth_token
  end

  def inbound_messages
    messages = client.account.sms.messages.list({:to => '+16463927288'}).select do |sms|
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