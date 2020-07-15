class SearchChannel < ApplicationCable::Channel
  def received(data)
    puts "RECEIVED DATA '#{data.inspect}'"
  end
end
