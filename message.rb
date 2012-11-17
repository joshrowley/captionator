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
    debugger
    messages.each {|message| create content: message.body, number: message.from, date_created: message.date_created }
  end
end