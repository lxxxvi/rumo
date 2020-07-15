class Admin::Visits::ConfirmationsController < Admin::BaseController
  before_action :set_visit!

  def create
    @visit.confirm!

    partial = self.class.render layout: false, partial: 'visits/list_item', locals: { visit: @visit }
    VisitChannel.broadcast_to(@visit, partial: partial)

    redirect_to admin_visits_path
  end

  private

  def set_visit!
    @visit = current_host.visits.find_by!(token: params[:visit_token])
  end
end
