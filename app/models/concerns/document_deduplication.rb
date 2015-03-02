concern :DocumentDeduplication do
  included do
    before_validation(on: [:create, :update]) do
      if duplicates.any?
        merge_duplicates!
      end
    end
  end

  def merge_with!(document)
    # TODO: steal incoming links. But maybe we don't need to do this?
    really_destroy!
  end

  # Find all duplicates and merge them into this document.
  def merge_duplicates!
    Rails.logger.info "Merging duplicates of #{url}"
    duplicates.each do |dupe|
      dupe.merge_with!(self)
    end
  end

  def duplicates
    Rails.logger.debug "Looking for duplicates of #{url}"
    user.documents.where("uid = ? or path = ?", uid, path).where("id != ?", id)
  end
end
