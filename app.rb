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
temp_array = []
condition_array = []
    for day in @forecast["daily"]["data"]
    temp_array << "#{day["temperatureHigh"]}" 
    condition_array << "#{day["summary"]}" 
    end
@future_temp = temp_array[0..6]
@future_condition = condition_array[0..6]


     view "ask"
end