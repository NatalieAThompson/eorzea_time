require "sinatra"
require "sinatra/reloader"

require_relative "timer"

configure do
  enable "sessions"
  set :sessions_secret, 'secret'
  set :erb, :escape_html => true
end

before do
  @time = Timer.new
  session[:items] ||= []
end

helpers do
  def format_time
    format("%02i:%02i", @time.hour, @time.minute)
  end
end

def sorted_items(items)
  current_time = format_time

  items = items.sort_by do |item|
    item[:time].to_s
  end

  before, after = items.partition do |item|
    item[:time].to_s < current_time
  end

  items = after + before
end

get "/" do
  @title = "Eorzea Time"
  @content = File.read("word.txt")
  @items = sorted_items(session[:items])

  erb :index
end

get "/login" do
  erb :login
end

def check_input(item, time)
  if item.empty?
    session[:message] = "Please input an item"
    redirect "/"
  elsif time.empty?
    session[:message] = "Please input a valid time"
    redirect "/"
  end
end

post "/add" do
  check_input(params[:item], params[:time])
  session[:items] << {name: params[:item], time: params[:time]}

  redirect("/")
end

post "/:item/delete" do |item|
  session[:items].reject! { |i| i[:name] == item }
  session[:message] = "#{item} was removed from the list."

  redirect "/"
end

get "/current_time" do
  format_time()
end

# Features to complete for this project
# Website night and day cycle
# Create a old fashioned clock within the blue circle
# keep the number clock as an option (click a button to turn on numbered time)
# need a get path for the javascript to check the list of times so that music can play on the site
# Order the things the user wants to gather by the nearest time
# When the time hits for a task play music and vibrate the clock like it is ringing
  # Have a clear disable button on the clock the user can click
# Add a database the contains all of the ffxiv gathering items and the times and places they spawn
  # A user should be able to add them to a list
# Be able to remove items from a list
# Have a menu for recently gathered items