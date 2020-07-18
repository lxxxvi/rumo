class VisitsController < ApplicationController
  def index
    @visits = Visit.joins(:host)
                   .includes(:host)
                   .of_uuid(session[:uuid])
                   .antichronological
  end

  def new
    @visit_form = VisitForm.new(host.visits.new)
  end

  def create
    @visit_form = VisitForm.new(host.visits.new, visit_params)

    if @visit_form.save
      redirect_to visits_url
    else
      render :new
    end
  end

  private

  def visit_params
    params.require(:visit)
          .permit(:name, :contact)
          .merge(uuid: session[:uuid])
  end

  def host
    @host = Host.find_by!(url_identifier: params[:host_url_identifier])
  end
end
