class VisitChannel < ApplicationCable::Channel
  def subscribed
    stream_for find_visit!
  end

  private

  def find_visit!
    Visit.of_uuid(current_uuid)
         .find_by!(token: params[:token])
  end
end
