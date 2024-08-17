require 'rails_helper'

RSpec.describe "Weather API", type: :request do

  it "returns current temperature" do
    get '/weather/current?city=Moscow'
    expect(response).to have_http_status(:success)
    expect(JSON.parse(response.body)).to have_key("temperature")
  end

  it "returns historical temperatures" do
    get '/weather/historical?city=Moscow'
    expect(response).to have_http_status(:success)
  end

  it "returns max temperature" do
    get '/weather/historical/max?city=Moscow'
    expect(response).to have_http_status(:success)
  end

  it "returns min temperature" do
    get '/weather/historical/min?city=Moscow'
    expect(response).to have_http_status(:success)
  end

  it "returns avg temperature" do
    get '/weather/historical/avg?city=Moscow'
    expect(response).to have_http_status(:success)
  end

  it "returns health status" do
    get '/weather/health'
    expect(response).to have_http_status(:success)
    expect(JSON.parse(response.body)).to eq({ "status" => "OK" })
  end

  describe 'GET /by_time' do
    let!(:city) { 'Moscow' }
    let!(:timestamp) { Time.now.to_i }
    let!(:temperature_record) { Temperature.create(city: city, value: 25.0, timestamp: Time.at(timestamp)) }

    context 'when temperature exists for the given city and timestamp' do
      it 'returns the temperature' do
        get '/by_time', params: { city: city, timestamp: timestamp }

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['city']).to eq(city)
        expect(json_response['temperature']).to eq(temperature_record.value)
      end
    end

    context 'when no temperature exists for the given city and timestamp' do
      it 'returns a 404 error' do
        get '/by_time', params: { city: city, timestamp: (timestamp + 1.day).to_i } # timestamp, который точно не существует

        expect(response).to have_http_status(404)
        expect(response.body).to include('No data available')
      end
    end

    context 'when city is not specified' do
      it 'returns the temperature for Moscow by default' do
        get '/by_time', params: { timestamp: timestamp }

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['city']).to eq('Moscow')
        expect(json_response['temperature']).to eq(temperature_record.value)
      end
    end
  end
end