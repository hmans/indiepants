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
    @post = current_site.posts.build(post_params)

    # Publish new posts right away
    @post.published_at = Time.now

    # Generate the post's URL and UID
    @post.slug = @post.generate_slug
    @post.url  = build_post_url(@post)

    # Render HTML
    @post.body_html = @post.generate_html

    # Save
    @post.save

    respond_with @post, location: :root
  end

  private

  def post_params
    params.require(:post).permit(:body)
  end

  def build_post_url(post)
    dt = post.published_at || post.created_at || Time.now
    nice_post_url(
      year:  dt.year.to_s.rjust(4, '0'),
      month: dt.month.to_s.rjust(2, '0'),
      day:   dt.day.to_s.rjust(2, '0'),
      slug: post.slug)
  end
end
