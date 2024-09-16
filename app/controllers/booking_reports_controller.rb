class BookingReportsController < ApplicationController
  def daily
    date = params[:date] ? Date.parse(params[:date]) : Date.today
    booking_events = BookingEvent.where(
      :created_at.gte => date.beginning_of_day,
      :created_at.lte => date.end_of_day
    )

    report = generate_report(booking_events, 'report by current day')

    render json: report
  end

  def monthly
    date = params[:date] ? Date.parse(params[:date]) : Date.today
    booking_events_current_month = BookingEvent.where(
      :created_at.gte => date.beginning_of_month,
      :created_at.lte => date.end_of_month
    )

    report = generate_report(booking_events_current_month, 'report by current month')

    render json: report
  end

  def weekly
    booking_events_last_week = BookingEvent.where(
      :created_at.gte => 1.week.ago.beginning_of_week,
      :created_at.lte => 1.week.ago.end_of_week
    )

    report = generate_report(booking_events_last_week, 'report by current weekly')

    render json: report
  end

  private

  def generate_report(booking_events, period_message)
    total_bookings = booking_events.count

    bookings_by_teacher = booking_events.group_by(&:teacher_id).transform_values(&:count)
    bookings_by_student = booking_events.group_by(&:student_id).transform_values(&:count)

    report = {
      date: period_message,
      total_bookings: total_bookings,
      bookings_by_teacher: bookings_by_teacher,
      bookings_by_student: bookings_by_student
    }

    bookings_by_hour = booking_events.group_by { |event| event.start_time.hour }.transform_values(&:count)
    peak_hour = bookings_by_hour.max_by { |_, count| count }&.first

    report[:bookings_by_hour] = bookings_by_hour
    report[:peak_hour] = peak_hour
    report
  end
end