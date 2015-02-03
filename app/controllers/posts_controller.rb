class PostsController < ApplicationController
  respond_to :html, :json

  def index
    @posts = current_site.posts.latest
    respond_with @posts
  end

  def show
    posts = current_site.posts
    @post = if params[:id]
      posts.find(params[:id])
    else
      date = Date.new(params[:year].to_i, params[:month].to_i, params[:day].to_i)
      posts
        .where(published_at: (date.beginning_of_day)..(date.end_of_day))
        .where(slug: params[:slug]).take!
    end
  end

  def create
    @post = current_site.posts.create(post_params)
    respond_with @post, location: :root
  end

private

  def post_params
    params.require(:post).permit(:body)
  end
end
