class PostsController < ApplicationController
  before_filter :set_board

  # GET /posts
  # GET /posts.json
  def index
    @posts = @board.posts.toplevel
    @post = @board.posts.build
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = @board.posts.find(params[:id])
  end

  # GET /posts/new
  # GET /posts/new.json
  def new
    @post = @board.posts.build
  end

  # GET /posts/1/edit
  def edit
    @post = @board.posts.find(params[:id])
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = @board.posts.build(params[:post])
    @post.post = @board.posts.find(params[:post_id])

    if @post.save
      redirect_to [@board, "posts"], notice: 'Post was successfully created.'
    else
      render action: "new"
    end
  end

  # PUT /posts/1
  # PUT /posts/1.json
  def update
    @post = @board.posts.find(params[:id])

    if @post.update_attributes(params[:post])
      redirect_to @post, notice: 'Post was successfully updated.'
    else
      render action: "edit"
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post = @board.posts.find(params[:id])
    @post.destroy

    redirect_to posts_url
  end

private
  def set_board
    @board = image_board.boards.find(params[:board_id])
  end
end
