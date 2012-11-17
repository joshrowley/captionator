require 'rack'
require './app.rb'

run Sinatra::Application
$stdout.sync = true