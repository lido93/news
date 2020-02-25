require "sinatra"
require "sinatra/reloader"
require "geocoder"
require "forecast_io"
require "httparty"
def view(template); erb template.to_sym; end
before { puts "Parameters: #{params}" }                                     

# enter your Dark Sky API key here
ForecastIO.api_key = "d9d3a275140f30b63342278b697655aa"

get "/" do
  # show a view that asks for the location
view "geocode"
end 

get "/news" do
  # do everything else
 
@results = Geocoder.search(params["q"])
@lat_long = @results.first.coordinates 
@city = params["q"]
 
#get current forecast 

    @forecast = ForecastIO.forecast(@lat_long[0], @lat_long[1]).to_hash 

    @current_temperature = @forecast["currently"]["temperature"]

    @conditions = @forecast["currently"]["summary"]

#get future forecast 
# temp_array = []
# condition_array = []
# low_temp_array = []
# day_of_week = [0,1,2,3,4,5,6]
#     for day in @forecast["daily"]["data"]
#     temp_array << "#{day["temperatureHigh"]}" 
#     condition_array << "#{day["summary"]}" 
#     low_temp_array << "#{day["temperatureLow"]}" 
#     end
# @future_temp = temp_array[0..6]
# @future_condition = condition_array[0..6]
# @future_low_temp = low_temp_array[0..6]


@url = "https://newsapi.org/v2/top-headlines?country=us&apiKey=9626f0bdeeac4f4a8999fe2a436b864c"
@news = HTTParty.get(@url).parsed_response.to_hash
# @less_news = news.slice(0, 9)
# news is now a Hash you can pretty print (pp) and parse for your output
    
    view "ask"
end