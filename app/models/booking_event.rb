class BookingEvent
  include Mongoid::Document
  include Mongoid::Timestamps

  field :teacher_id, type: Integer
  field :student_id, type: Integer
  field :slot_id, type: Integer
  field :start_time, type: DateTime
end