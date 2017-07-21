require './config/environment'
require './app/models/pizza_model'

class ApplicationController < Sinatra::Base
  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  get '/' do
    erb :index
  end
  
  post '/' do
    @neighborhood = params[:neighborhood]
    @hash = get_info(@neighborhood)
    @names = @hash[:names]
    # @address = @hash[:ad]
    @price = @hash[:prices]
    @rating = @hash[:ratings]
    @location1 = @hash[:locations1]
    @location2 = @hash[:locations2]
    @image = @hash[:pictures]
    @phone_number = @hash[:phone_number]
    erb :results
  end
end

