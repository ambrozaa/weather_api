require 'grape'
require 'httparty'
require 'rufus-scheduler'

module Weather
  class Api < Grape::API
    format :json

    scheduler = Rufus::Scheduler.new

    scheduler.every '30m' do
      update_weather_data('Moscow') # Замените 'Moscow' на нужный город
    end

    resource :weather do
      helpers do
        def fetch_current_temperature(city)
          location_key = get_location_key(city)
          response = HTTParty.get("https://dataservice.accuweather.com/currentconditions/v1/#{location_key}?apikey=#{ENV['ACCUWEATHER_API_KEY']}")
          response.parsed_response.first['Temperature']['Metric']['Value']

        end

        def get_location_key(city)
          response = HTTParty.get("https://dataservice.accuweather.com/locations/v1/cities/search?apikey=#{ENV['ACCUWEATHER_API_KEY']}&q=#{city}")
          response.parsed_response.first['Key']

        end

        def save_temperature(city, value)
          Temperature.create(city: city, timestamp: Time.now, value: value)
        end
      end

      get :current do
        city = params[:city] || 'Moscow'
        temperature = fetch_current_temperature(city)
        save_temperature(city, temperature)
        { city: city, temperature: temperature }
      end

      get 'historical' do
        city = params[:city] || 'Moscow'
        temperatures = Temperature.where(city: city).order(timestamp: :desc).limit(24)
        temperatures.map { |temp| { timestamp: temp.timestamp, value: temp.value } }

      end

      get 'historical/max' do
        city = params[:city] || 'Moscow'
        max_temp = Temperature.where(city: city).maximum(:value)
        { city: city, max_temperature: max_temp }
      end

      get 'historical/min' do
        city = params[:city] || 'Moscow'
        min_temp = Temperature.where(city: city).minimum(:value)
        { city: city, min_temperature: min_temp }
      end

      get 'historical/avg' do
        city = params[:city] || 'Moscow'
        avg_temp = Temperature.where(city: city).average(:value)
        { city: city, avg_temperature: avg_temp }
      end

      get 'by_time' do
        city = params[:city] || 'Moscow'
        timestamp = params[:timestamp].to_i unless params[:timestamp].blank?

        temperature = Temperature.where(city: city, timestamp: timestamp).first

        if temperature
          render json: { city: city, temperature: temperature.value }, status: :ok
        else
          error!('No data available', 404)
        end
      end

      get :health do
        { status: 'OK' }
      end
    end
  end
end