# ----------------------------------------------------
# name: comment_observer.rb
# authors: Jason Lee<huacnlee@gmail.com>,
# create at: 2009-04-20
# summary:
#   this comment_observer.rb summary
# ----------------------------------------------------
class CommentObserver < ActiveRecord::Observer
  
  def after_create(m)
    total_comment_count(m)
  end
  
  def after_destroy(m)
    total_comment_count(m)
  end
  
  private
  # tatal the comments count of this post and save it.
  def total_comment_count(m)
    @post = m.post
    @count = @post.comments.length
    @post.comment_count = @count
    @post.save
  end
end