# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  before_filter :init
  
  # 初始化
  def init
    @menus = Rails.cache.read("data/menus")
    if @menus.blank?
      @menus = Menu.find_all
      Rails.cache.write("data/menus",@menus)
    end
    
    @setting = Rails.cache.read("data/setting")
    if @setting.blank?
      @setting = Setting.find_create
      Rails.cache.write("data/setting",@setting)
    end
  end

  # 输出404错误
  def render_404
    render_optional_error_file(404)
  end
  
  # 设置主菜单的活动标签
  def set_nav_actived(name = "home")
    @nav_actived = name
  end
  
  # 设置SEO 的Meta 值
  def set_seo_meta(title,keywords = '',desc = '')
    if title
      @page_title =  "#{title} - #{@setting.site_name}"
    else
      @page_title = @setting.site_name
    end
    @meta_keywords = keywords
    @meta_description = desc
  end
  
end