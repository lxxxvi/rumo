class HomeController < ApplicationController
  def index
    @goto_hosts_form = GotoHostsForm.new(goto_hosts_params)
    @visits_count = Visit.of_uuid(session[:uuid]).count

    if @goto_hosts_form.validatable? && @goto_hosts_form.valid?
      redirect_to visit_path(@goto_hosts_form.host)
    end
  end

  private

  def goto_hosts_params
    params[:goto_hosts_form]&.permit(:host_url_identifier)
  end
end
