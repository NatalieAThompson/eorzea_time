require "sinatra"
require "sinatra/reloader"
require "bcrypt"
require "yaml"
require "fileutils"
require 'sinatra/cross_origin'

require_relative "timer"

configure do
  enable :cross_origin
  enable "sessions"
  set :sessions_secret, 'secret'
  set :erb, :escape_html => true
end

before do
  response.headers['Access-Control-Allow-Origin'] = '*'
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
  if session[:username] || session[:guest]
    @items = sorted_items(session[:items])

    erb :index
  else
    redirect "/login"
  end
end

get "/login" do
  erb :login
end

def save_session
  File.open("./data/#{session[:username]}/items.yaml", "w") do |file|
    file.write(session[:items].to_yaml)
  end
end

get "/signup" do
  erb :signup
end

def include_capital?(password)
  password.match?(/[A-Z]/)
end

def include_lowercase?(password)
  password.match?(/[a-z]/)
end

def include_number?(password)
  password.match?(/[0-9]/)
end

def include_symbol?(password)
  password.match?(/[\!\@\#\$\%\^\&\*\(\)\_\-\+\=\~\`\?\>\<\:\;\"\'\{\}\[\]\\\|]/)
end

def halt_progress(message)
  session[:message] = message
  status 422
  halt erb :signup
end

def secure?(password)
  if !include_capital?(password)
    halt_progress("Your password must contain at least 1 uppercase letter.")
  elsif !include_lowercase?(password)
    halt_progress("Your password must contain at least 1 lowercase letter.")
  elsif !include_number?(password)
    halt_progress("Your password must contain at least 1 digit.")
  elsif !include_symbol?(password)
    halt_progress("Your password must contain at least 1 symbol.")
  elsif password.length < 6
    halt_progress("Your password must be at least 6 letters long.")
  end
  true
end

def matching?(password, password2)
  password == password2
end

def encrypt(password)
  BCrypt::Password.create(password).to_s
end

def add_new_user(username, password)
  users = load_users
  new_user = { username => encrypt(password) }
  users.merge! new_user
  File.open("./data/config.yaml", "w") do |file|
    file.write(users.to_yaml)
  end
end

post "/signup" do
  password, password2, username = params[:password], params[:password2], params[:username]
  if user_exists?(username)
    halt_progress("The username you entered is already taken.")
  elsif secure?(password) && matching?(password, password2)
    add_new_user(username, password)
    session[:message] = "Your account has been created. Please login."
    redirect "/login"
  else
    halt_progress("The passwords do not match.")
  end
end

post "/logout" do
  save_session
  session.delete(:username)
  session.delete(:items)

  redirect "/login"
end

def load_items
  if File.directory?("./data/#{session[:username]}")
    YAML.load(File.read("./data/#{session[:username]}/items.yaml"))
  else
    FileUtils.mkdir_p("./data/#{session[:username]}")
    []
  end
end

def load_users
  YAML.load(File.read("./data/config.yaml"))
end

def user_exists?(name)
  users = load_users
  users.keys.include?(name)
end

def password_matches(user, password)
  BCrypt::Password.new(user) == password
end

def correct_login?(name, password)
  users = load_users
  user_exists?(name) && password_matches(users[name], password)
end

post "/login" do
  username = params[:username]
  password = params[:password]
  if correct_login?(username, password)
    session[:username] = username
    session[:message] = "You have logged in as #{username}."
    session[:items] = load_items

    redirect "/"
  else
    session[:message] = "Invalid Credentials"
    status 422

    erb :login
  end
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

post "/guest" do
  session[:guest] = true

  redirect "/"
end

get "/current_time" do
  format_time()
end

options "*" do
  response.headers["Allow"] = "GET, PUT, POST, DELETE, OPTIONS"
  response.headers["Access-Control-Allow-Headers"] = "Authorization, Content-Type, Accept, X-User-Email, X-Auth-Token"
  response.headers["Access-Control-Allow-Origin"] = "*"
  200
end

# Features to complete for this project
# Website night and day cycle
# When the time hits for a task play music and vibrate the clock like it is ringing
  # Have a clear disable button on the clock the user can click
# Add a database the contains all of the ffxiv gathering items and the times and places they spawn
  # A user should be able to add them to a list
# Have a menu for recently gathered items.