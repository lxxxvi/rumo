class Admin::DownloadsController < ApplicationController
  def new
    @form = Admin::DownloadForm.new(current_host, selected_date: Time.zone.today)
  end

  def create
    @form = Admin::DownloadForm.new(current_host, download_params)

    if @form.valid?
      service = VisitsDownloadService.new(current_host, @form.validated_selected_date)
      send_data(service.to_csv, filename: service.filename)
    else
      render :new
    end
  end

  private

  def download_params
    params.require(:admin_download).permit(:selected_date)
  end
end
