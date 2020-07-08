class Coaches::AttendancesController < Coaches::BaseController
  def index
    @attendances = Attendance.antichronological
  end

  def confirm
    attendance = Attendance.find_by!(token: params[:token])
    attendance.confirm!

    partial = self.class.render layout: false, partial: 'attendances/list_item', locals: { attendance: attendance }
    AttendanceChannel.broadcast_to(attendance, partial: partial)

    redirect_to coaches_attendances_path
  end

  def destroy
    attendance = Attendance.find_by!(token: params[:token])
    attendance.destroy!

    AttendanceChannel.broadcast_to(attendance, partial: nil)
    redirect_to coaches_attendances_path
  end
end
