require "sinatra"
require "sinatra/reloader"

require_relative "timer"

before do
  @time = Timer.new
end

helpers do
  def format_time
    format("%02i:%02i", @time.hour, @time.minute)
  end
end

get "/" do
  @title = "Eorzea Time"
  @content = File.read("word.txt")
  # @script = File.read("scripts/main.js")
  erb :index
end