class Admin::VisitsController < Admin::BaseController
  def index
    @visit_statistics = VisitsStatisticsService.new(current_host).statistics
    @visits = current_host.visits.antichronological

    @visits = if confirmed_only?
                @visits.confirmed
              else
                @visits.unconfirmed
              end
  end

  private

  def confirmed_only?
    filter_params&.dig(:status) == 'confirmed'
  end

  def filter_params
    params[:filter]&.permit(:status)
  end
end
