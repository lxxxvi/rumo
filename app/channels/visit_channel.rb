class VisitChannel < ApplicationCable::Channel
  def subscribed
    visit = find_visit
    return reject if visit.nil?

    stream_for visit
  end

  private

  def find_visit
    Visit.of_uuid(current_uuid).find_by(token: params[:token])
  end
end
