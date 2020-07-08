class AttendanceDecorator < SimpleDelegator
  def display_status
    @display_status ||= status.to_s.capitalize
  end
end
