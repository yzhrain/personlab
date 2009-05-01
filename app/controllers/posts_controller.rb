class PostsController < ApplicationController
  cache_sweeper :post_sweeper,:only => [:comment]
  before_filter :init_posts
  
  private
  def init_posts
    set_nav_actived("blog")
  end
  
  public
  def index
    set_seo_meta("博客")
    if !fragment_exist? "posts/index/#{params[:page]}"
      @posts = Post.find_list_with_front(params[:page])
    end
  end
  
  def comment
    @post = Post.find_by_slug(params[:slug])
    
    if not @post
      render_404
    end
    
    # post comment
    @pcomment = params[:comment]
    @comment = Comment.new(params[:comment])
    @comment.post_id = @post.id
    @comment.status = 1
    
    if @comment.save
      flash[:notice] = "Comment successed."
      redirect_to :action => "show", :slug => @post.slug
    end
  end
  
  def show
    @view_count_delay = 10
    @post_key = "data/posts/#{params[:slug]}"
    @view_count_key = "data/posts/#{params[:slug]}/view_count_delay"
    @view_count = 0
    
    # update pv
    @view_count = Rails.cache.read(@view_count_key).to_i || 0
    if @view_count % @view_count_delay == 0 && @view_count != 0
      Post.update_view_count(params[:slug],@view_count)
      @view_count = 0
    else
      @view_count += 1
    end
    Rails.cache.write(@view_count_key,@view_count)
    
    @post = Rails.cache.read(@post_key)
    if (not @post) or (@view_count == 0)
      @post = Post.find_slug(params[:slug])
      if not @post
        return render_404
      end
      
      Rails.cache.write(@post_key,@post)
    end
    
    # get comments list
    if !fragment_exist? "posts/show/#{params[:slug]}/comments"
      @comments = @post.comments.find_list
    end
    
    @comment = Comment.new
  end
  
end