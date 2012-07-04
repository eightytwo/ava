class CommentAuthorizer < ApplicationAuthorizer
  # A comment can only be updated by its owner.
  #
  def updatable_by?(user)
    user == resource.user
  end
end
