scheduler = Rufus::Scheduler.new

scheduler.every '30m' do
  WeatherJob.perform_later('Moscow') # Замените 'Moscow' на нужный город
end