module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_uuid

    def connect
      self.current_uuid = cookies.signed[:uuid]
    end
  end
end
