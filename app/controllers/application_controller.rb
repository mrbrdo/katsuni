class ApplicationController < ActionController::Base
  protect_from_forgery

  def image_board
    @image_board ||= ImageBoard.new
  end
end
