ActionController::Routing::Routes.draw do |map|

  map.root :controller => "home"  

  # Control Panel 
  map.namespace(:cpanel) do |cpanel|
    cpanel.root :controller => "home"  
    cpanel.login "login",:controller => "home", :action => "login" 
    cpanel.login "logout",:controller => "home", :action => "logout" 
    
    cpanel.login "posts/importblogbus", :controller => "posts", :action => "importblogbus"
    
    cpanel.resources :menus,:pages,:posts,:comments,:settings
    
    
  end
  
  # Share
  
  # Blog
  map.purchase "blog", :controller => "posts"
  map.purchase "blog", :controller => "posts", :action => "index"
  map.purchase "blog/rss", :controller => "posts", :action => "rss"
  map.purchase "blog/page/:page", :controller => "posts", :action => "index", :requirements => { :page => /[\d]+/ }
  map.purchase "blog/:slug", :controller => "posts", :action => "show", :requirements => { :slug => /[a-z0-9A-Z\-\_\.]+/ }
 
  map.purchase "share", :controller => "home", :action => "share"
 
  # Pages (This well be stay last line)
  map.purchase ":slug", :controller => "home", :action => "show", :requirements => { :slug => /[a-z0-9A-Z\-\_\.]+/ }
  
  # base routes
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  
end
