require 'sinatra'
require 'data_mapper'

set :bind, '0.0.0.0'

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/to_do_app.db")

class Item
	include DataMapper::Resource
	property :id, Serial
	property :content, Text, :required => true
	property :done, Boolean, :required => true, :default => false
	property :created, DateTime
end
DataMapper.finalize.auto_upgrade!

get '/' do
	@items = Item.all(:order => :created.desc)
	redirect '/new' if @items.empty?
	erb :index
end

get '/new' do
	erb :new
end

post '/new' do
	Item.create(:content => params[:content], :created => Time.now)
	redirect '/'
end

get '/delete/:id' do
	@item = Item.first(:id => params[:id])
	erb :delete
end

post '/delete/:id' do
	if params.has_key?("ok")	
		item = Item.first(:id => params[:id])
		item.destroy
		redirect'/'
	else
		redirect'/'
	end
end