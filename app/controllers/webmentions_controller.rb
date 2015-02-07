class WebmentionsController < ApplicationController
  protect_from_forgery except: [:create]

  def create
    @source = params.require(:source)
    @target = params.require(:target)

    # TODO: lots of stuff.

    render text: "OK", status: 202
  end
end
