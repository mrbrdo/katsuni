class BoardsController < ApplicationController
  # GET /boards
  # GET /boards.json
  def index
    @boards = image_board.boards.all
  end
end
