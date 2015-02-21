concern :DocumentDeduplication do
  def find_original
    if uid.present?
      user.documents.where(uid: uid).where("id != ?", id).take
    end
  end
end
