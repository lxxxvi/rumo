module ApplicationHelper
  def render_svg(file_name)
    Pathname.new("app/assets/images/#{file_name}").read
  end
end
