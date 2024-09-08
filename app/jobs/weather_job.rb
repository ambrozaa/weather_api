class WeatherJob < ApplicationJob
  queue_as :default

  def perform(city)
    WeatherService.new(city).update_weather_data
  end
end
