class Admin::VisitsController < Admin::BaseController
  before_action :set_visit, only: %i[update destroy]

  def index
    @visit_statistics = VisitsStatisticsService.new(current_host).statistics
    @visits = current_host.visits.antichronological

    @visits = if confirmed_only?
                @visits.confirmed
              else
                @visits.unconfirmed
              end
  end

  def update
    form = Admin::VisitForm.new(@visit, update_params)
    form.save

    broadcast_change(visit: form.object)

    redirect_to admin_visits_path
  end

  def destroy
    @visit.destroy
    broadcast_change(visit: @visit)

    redirect_to admin_visits_path
  end

  private

  def set_visit
    @visit = current_host.visits.find_by!(token: params[:token])
  end

  def confirmed_only?
    filter_params&.dig(:status) == 'confirmed'
  end

  def update_params
    params.require(:admin_visit).permit(:notes)
  end

  def filter_params
    params[:filter]&.permit(:status)
  end

  def broadcast_change(visit:)
    if visit.destroyed?
      VisitChannel.broadcast_to(visit, partial: nil)
    else
      partial = self.class.render layout: false, partial: 'visits/list_item', locals: { visit: visit }
      VisitChannel.broadcast_to(visit, partial: partial)
    end
  end
end
