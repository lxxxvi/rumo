class My::VisitsController < ApplicationController
  def index
    @visits = Visit.joins(:host)
                   .includes(:host)
                   .of_uuid(session[:uuid])
                   .antichronological
  end
end
