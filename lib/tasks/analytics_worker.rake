namespace :worker do
  desc 'Start the analytics worker'
  task start_analytics_worker: :environment do
    AnalyticsWorker.start
  end
end