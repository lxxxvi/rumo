class Admin::Visits::RejectionsController < Admin::BaseController
  def create
    visit = current_host.visits.find_by!(token: params[:visit_token])
    visit.destroy!

    VisitChannel.broadcast_to(visit, partial: nil)
    redirect_to admin_visits_path
  end
end
