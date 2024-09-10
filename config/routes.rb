Rails.application.routes.draw do
  get '/booking_reports/daily', to: 'booking_reports#daily'
  get '/booking_reports/monthly', to: 'booking_reports#monthly'
  get '/booking_reports/weekly', to: 'booking_reports#weekly'
end
