ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
  map.home '', :controller => "main"
  
  # This is the "root" route with the implicit defaults listed
  #map.connect '', :controller => "main", :action => 'index', :id => nil
  
  map.archive 'archive/:year/:month', :controller => "main", :action => 'archive', :year => 2006, :month => 1, :requirements => {:year => /\d{4}/, :month => /\d{1,2}/}

  # Examples of aliasing routes
  map.connect 'main/:action/:id', :controller => "main", 
    :requirements => {:action => /(list|category)/ }
  map.connect 'foo/:action/:id', :controller => "main"
  map.connect 'admin/:action/:id', :controller => 'staff'
  
  map.connect 'course/:id', :controller => "main", :action => 'view_course', :id => 1
  
  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  #map.connect ':controller/service.wsdl', :action => 'wsdl'

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
end
