class Admin::HomeController < Admin::BaseController
  def index
    @unconfirmed_host_visits_count = current_host.visits.unconfirmed.count
  end
end
