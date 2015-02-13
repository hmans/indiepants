class Pants::DocumentsController < ApplicationController
  respond_to :html, :json

  def index
    @documents = current_site.documents.latest

    respond_with @documents do |format|
      format.atom
    end
  end

  def show
    @document = find_document_by_id ||
      find_document_by_date_and_slug ||
      find_document_by_previous_url

    # TODO: serve a proper 404 here
    raise "document not found" if @document.blank?

    # If document has been soft-deleted, serve 401 Gone
    if @document.deleted?
      # TODO: render this in a somewhat nicer fashion.
      # TODO: deal with JSON-specific requests
      return render text: '410 Gone', status: 410
    end

    # Enforce canonical URL
    if request.format.html? && request.url != @document.url
      return redirect_to(@document.url, status: 301)
    end

    respond_with @document
  end

  def new
    @document = current_site.documents.build
    respond_with @document
  end

  def create
    # A bit of a workaround; if we feed the type to Document.new directly,
    # ActiveRecord apparently doesn't go through .find_sti_class at all.
    #
    klass = Document.find_sti_class(params[:document][:type])

    # Create the document
    @document = klass.create(document_params) do |document|
      document.user = current_site
    end

    respond_with @document, location: @document.url
  end

  def edit
    @document = current_site.documents.find(params[:id])
    respond_with @document
  end

  def update
    @document = current_site.documents.find(params[:id])
    @document.update_attributes(document_params)
    respond_with @document, location: @document.url
  end

  def destroy
    @document = current_site.documents.find(params[:id])
    @document.destroy
    respond_with @document, location: :root
  end


private

  def document_params
    params.require(:document).permit(:slug, :body)
  end

  def find_document_by_id
    current_site.documents
      .with_deleted
      .find(params[:id]) if params[:id]
  end

  def find_document_by_date_and_slug
    date = Date.new(params[:year].to_i, params[:month].to_i, params[:day].to_i)
    current_site.documents
      .with_deleted
      .where(published_at: (date.beginning_of_day)..(date.end_of_day))
      .where(slug: params[:slug]).take
  end

  def find_document_by_previous_url
    current_site.documents
      .with_deleted
      .where("? = ANY (previous_urls)", request.url).take
  end
end