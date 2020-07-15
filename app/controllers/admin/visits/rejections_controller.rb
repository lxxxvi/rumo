class Admin::Visits::RejectionsController < Admin::BaseController
  before_action :set_visit!

  def create
    @visit.destroy!

    VisitChannel.broadcast_to(@visit, partial: nil)
    redirect_to admin_visits_path
  end

  private

  def set_visit!
    @visit ||= current_host.visits.find_by!(token: params[:visit_token])
  end
end
