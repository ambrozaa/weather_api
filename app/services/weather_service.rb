class WeatherService

  API_KEY = ENV['ACCUWEATHER_API_KEY']
  BASE_URL = 'https://dataservice.accuweather.com'.freeze
  def initialize(city)
    @city = city
  end

  def update_weather_data
    temperature = fetch_current_temperature
    save_temperature(temperature)
  end

  def fetch_current_temperature
    cache_key = "current_temperature_#{@city}"
    Rails.cache.fetch(cache_key, expires_in: 30.minutes) do
      location_key = get_location_key
      response = HTTParty.get("#{BASE_URL}/currentconditions/v1/#{location_key}?apikey=#{API_KEY}")
      raise "Error fetching temperature" unless response.success?
      response.parsed_response.first['Temperature']['Metric']['Value']
    end
  end

  def get_location_key
    cache_key = "location_key_#{@city}"
    Rails.cache.fetch(cache_key, expires_in: 1.day) do
      response = HTTParty.get("#{BASE_URL}/locations/v1/cities/search?apikey=#{API_KEY}&q=#{@city}")
      raise "Error fetching location key" unless response.success?
      response.parsed_response.first['Key']
    end
  end

  def save_temperature(value)
    Temperature.create(city: @city, timestamp: Time.now, value: value)
  end

end