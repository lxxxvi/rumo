class Admin::SettingsController < Admin::BaseController
  def edit
    @settings_form = Admin::SettingsForm.new(current_host)
  end

  def update
    @settings_form = Admin::SettingsForm.new(current_host, admin_settings_params)

    if @settings_form.save
      flash[:notice] = 'Settings updated successfully.'
      redirect_to edit_admin_settings_path
    else
      render :edit
    end
  end

  private

  def admin_settings_params
    params.require(:admin_settings).permit(:name, :url_identifier, :auto_confirm_visits, :notes_enabled)
  end
end
