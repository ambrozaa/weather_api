class TemperatureService
  def initialize(city)
    @city = city
  end

  def historical_data
    Temperature.where(city: @city).order(timestamp: :desc).limit(24)
  end

  def max_temperature
    historical_data.maximum(:value)
  end

  def min_temperature
    historical_data.minimum(:value)
  end

  def avg_temperature
    historical_data.average(:value)
  end

  def temperature_by_time(timestamp)
    Temperature.where(city: @city, timestamp: Time.at(timestamp)).first
  end
end