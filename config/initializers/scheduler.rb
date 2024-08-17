require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new

scheduler.every '1h' do
  UpdateWeatherDataJob.perform_later
end