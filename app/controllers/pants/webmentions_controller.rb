module Pants
  class WebmentionsController < ApplicationController
    protect_from_forgery except: [:create]

    def create
      @source = params.require(:source)
      @target = params.require(:target)

      render text: "OK", status: 202

      Background.go { process_webmention(@source, @target) }
    end

  private

    def process_webmention(source, target)
      # check if target URL is on this domain
      return false unless URI(target).host == current_site.host

      # check if target document actually exists
      target_document = current_site.documents.find_by_path_or_previous_path(URI(target).path)
      return false unless target_document

      # discard source document if it doesn't actually contain a link
      return false unless Fetch.nokogiri(source).css('a').any? { |a| a['href'] == target }

      # fetch source document
      source_document = Pants::Document.from_url(source)
    end
  end
end
