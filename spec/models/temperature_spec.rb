require 'rails_helper'

RSpec.describe Temperature, type: :model do

    it 'is valid with valid attributes' do
      weather_data = Temperature.new(city: 'Mowscow', value: 25.5, timestamp: Time.now)
      expect(weather_data).to be_valid
    end

    it 'is not valid without a temperature' do
      weather_data = Temperature.new(city: 'Mowscow', timestamp: Time.now)
      expect(weather_data).not_to be_valid
    end

    it 'is not valid without a recorded_at timestamp' do
      weather_data = Temperature.new(city: 'Mowscow', value: 25.5)
      expect(weather_data).not_to be_valid
    end

    it 'saves the data correctly to the database' do
      weather_data = Temperature.create(city: 'Mowscow', value: 25.5, timestamp: Time.now)
      expect(Temperature.find_by(value: 25.5)).to eq(weather_data)
    end
end

