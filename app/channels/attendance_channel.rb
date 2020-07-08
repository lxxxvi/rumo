class AttendanceChannel < ApplicationCable::Channel
  def subscribed
    attendance = Attendance.find_by!(token: params[:token])
    stream_for attendance
  end

  def unsubscribed
  end
end
