class AttendancesController < ApplicationController
  before_action :set_attendance, only: %i[show edit update destroy]

  def list
    if params[:tokens].nil?
      render status: 404
    else
      tokens = params[:tokens].split(',')

      @attendances = Attendance.where(token: tokens).antichronological
      render layout: false, partial: 'attendances/list', locals: { attendances: @attendances }
    end
  end

  def show
  end

  def new
    @attendance = Attendance.new
  end

  def create
    @attendance = Attendance.new(attendance_params)

    if @attendance.save
      redirect_to @attendance
    else
      render :new
    end
  end

  private
    def set_attendance
      @attendance = Attendance.find_by!(token: params[:token])
    end

    def attendance_params
      params.require(:attendance).permit(:name, :contact)
    end
end
