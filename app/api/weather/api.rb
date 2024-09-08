module Weather
  class Api < Grape::API
    format :json

    resource :weather do
      desc 'Get current temperature'
      params do
        optional :city, type: String, default: 'Moscow'
      end
      get :current do
        city = params[:city]
        temperature = WeatherService.new(city).fetch_current_temperature
        WeatherJob.perform_later(city) # Запускаем задачу по обновлению данных
        { city: city, temperature: temperature }
      end

      desc 'Get historical temperature data for the last 24 hours'
      params do
        optional :city, type: String, default: 'Moscow'
      end
      get :historical do
        city = params[:city]
        temperatures = TemperatureService.new(city).historical_data
        temperatures.map { |temp| { timestamp: temp.timestamp, value: temp.value } }
      end

      desc 'Get maximum temperature for the last 24 hours'
      params do
        optional :city, type: String, default: 'Moscow'
      end
      get 'historical/max' do
        city = params[:city]
        max_temp = TemperatureService.new(city).max_temperature
        { city: city, max_temperature: max_temp }
      end

      desc 'Get minimum temperature for the last 24 hours'
      params do
        optional :city, type: String, default: 'Moscow'
      end
      get 'historical/min' do
        city = params[:city]
        min_temp = TemperatureService.cnew(ity).min_temperature
        { city: city, min_temperature: min_temp }
      end

      desc 'Get average temperature for the last 24 hours'
      params do
        optional :city, type: String, default: 'Moscow'
      end
      get 'historical/avg' do
        city = params[:city]
        avg_temp = TemperatureService.new(city).avg_temperature
        { city: city, avg_temperature: avg_temp }
      end

      desc 'Get temperature closest to a specific timestamp'
      params do
        requires :timestamp, type: Integer
        optional :city, type: String, default: 'Moscow'
      end
      get 'by_time' do
        city = params[:city]
        timestamp = params[:timestamp]
        temperature = TemperatureService.new(city).temperature_by_time(timestamp)
        if temperature
          { city: city, temperature: temperature.value }
        else
          error!('No data available', 404)
        end
      end

      desc 'Health check endpoint'
      get :health do
        { status: 'OK' }
      end
    end
  end
end