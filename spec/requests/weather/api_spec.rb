require 'rails_helper'

RSpec.describe 'Weather API', type: :request do
  before do
    # Убедитесь, что данные очищены перед выполнением тестов
    Temperature.destroy_all
  end

  describe 'GET /weather/current', :vcr do
    it 'returns current temperature' do
      get '/weather/current', params: { city: 'Moscow' }
      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(json_response).to have_key('temperature')
      expect(json_response['city']).to eq('Moscow')
    end
  end

  describe 'GET /weather/historical', :vcr do
    it 'returns historical temperatures' do
      get '/weather/historical', params: { city: 'Moscow' }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /weather/historical/max', :vcr do
    it 'returns max temperature' do
      get '/weather/historical/max', params: { city: 'Moscow' }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /weather/historical/min', :vcr do
    it 'returns min temperature' do
      get '/weather/historical/min', params: { city: 'Moscow' }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /weather/historical/avg', :vcr do
    it 'returns avg temperature' do
      get '/weather/historical/avg', params: { city: 'Moscow' }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /weather/by_time', :vcr do
    let!(:city) { 'Moscow' }
    let!(:timestamp) { Time.now.to_i }
    let!(:temperature_record) { Temperature.create!(city: city, value: 25.0, timestamp: Time.at(timestamp)) }

    context 'when temperature exists for the given city and timestamp' do
      it 'returns the temperature' do
        get '/weather/by_time', params: { city: city, timestamp: timestamp }
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['city']).to eq(city)
        expect(json_response['temperature']).to eq(temperature_record.value)
      end
    end

    context 'when city is not specified' do
      it 'returns the temperature for Moscow by default' do
        get '/weather/by_time', params: { timestamp: timestamp }
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['city']).to eq('Moscow')
        expect(json_response['temperature']).to eq(temperature_record.value)
      end
    end
  end

  describe 'GET /weather/health' do
    it 'returns health status' do
      get '/weather/health'
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)).to eq({ 'status' => 'OK' })
    end
  end
end