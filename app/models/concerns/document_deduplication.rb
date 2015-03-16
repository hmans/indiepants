concern :DocumentDeduplication do
  included do
    before_save do
      if remote? && duplicates.any?
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
    raise "deduplication should never run for local documents" if local?

    Rails.logger.info "Merging duplicates of #{url}"
    duplicates.each do |dupe|
      dupe.merge_with!(self)
    end
  end

  def duplicates
    Rails.logger.debug "Looking for duplicates of #{url}"

    # TODO: refactor the following using ActiveRecord's upcoming .or() invocation
    scope = user.documents
    if uid.present? && path.present?
      scope = scope.where("uid = ? or path = ?", uid, path)
    elsif uid.present?
      scope = scope.where(uid: uid)
    elsif path.present?
      scope = scope.where(path: path)
    end

    if persisted?
      scope = scope.where("id != ?", id)
    end

    scope
  end
end
