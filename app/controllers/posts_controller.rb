class PostsController < ApplicationController
  respond_to :html, :json

  def index
    @posts = current_site.posts.latest
    respond_with @posts
  end

  def show
    @post = find_post_by_id ||
      find_post_by_date_and_slug ||
      find_post_by_previous_url

    raise "post not found" if @post.blank?

    # Enforce canonical URL
    if request.format.html? && request.url != @post.url
      return redirect_to(@post.url, status: 301)
    end

    respond_with @post
  end

  def new
    @post = current_site.posts.build
    respond_with @post
  end

  def create
    # A bit of a workaround; if we feed the type to Post.new directly,
    # ActiveRecord apparently doesn't go through .find_sti_class at all.
    #
    klass = Post.find_sti_class(params[:post][:type])

    # Create the post
    @post = klass.create(post_params) do |post|
      post.user = current_site
    end

    respond_with @post, location: @post.url
  end

  def edit
    @post = current_site.posts.find(params[:id])
    respond_with @post
  end

  def update
    @post = current_site.posts.find(params[:id])
    @post.update_attributes(post_params)
    respond_with @post, location: @post.url
  end

  def destroy
    @post = current_site.posts.find(params[:id])
    # TODO: don't actually destroy the post; just mark it as destroyed.
    @post.destroy
    respond_with @post, location: :root
  end


private

  def post_params
    params.require(:post).permit(:slug, :body)
  end

  def find_post_by_id
    current_site.posts.find(params[:id]) if params[:id]
  end

  def find_post_by_date_and_slug
    date = Date.new(params[:year].to_i, params[:month].to_i, params[:day].to_i)
    current_site.posts
      .where(published_at: (date.beginning_of_day)..(date.end_of_day))
      .where(slug: params[:slug]).take
  end

  def find_post_by_previous_url
    current_site.posts.where("? = ANY (previous_urls)", request.url).take
  end
end
