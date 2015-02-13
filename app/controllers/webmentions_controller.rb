class WebmentionsController < ApplicationController
  protect_from_forgery except: [:create]

  def create
    @source = params.require(:source)
    @target = params.require(:target)

    render text: "OK", status: 202

    Thread.new do
      process_webmention(@source, @target)
    end
  end

private

  def process_webmention(source, target)
    # check if target is on this domain
    return false unless URI(target).host == current_site.host

    # Create a new Webmention instance and let it handle everything else
    current_site.webmentions.create!(source, target)
  end
end
