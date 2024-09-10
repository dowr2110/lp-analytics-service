class AnalyticsWorker
  def self.start
    Services::RabbitmqService.subscribe('analytics_queue') do |data|
      process_event(data)
    end
  end

  def self.process_event(data)
    case data['event']
    when 'new_booking'
      BookingEvent.create!(
        teacher_id: data['teacher_id'],
        student_id: data['student_id'],
        slot_id: data['slot_id'],
        created_at: data['created_at']
      )
      puts 'New booking event saved.'
    end
  end
end
