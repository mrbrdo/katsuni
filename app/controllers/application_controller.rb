class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :check_ip

  def check_ip
    unless IpCheckerSingleton.valid_ip?(request.remote_ip)
      raise "Invalid IP!"
      # TODO: add google, search engines as valid
    end
  end

  def image_board
    @image_board ||= ImageBoard.new
  end
end
