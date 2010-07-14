ActionController::Routing::Routes.draw do |map|
  map.devise_for :admins
  map.devise_for :people

  map.connect '/admin/events/ingest', :controller => 'admin/events', :action => 'ingest'
  map.admin_event_hide '/admin/events/hide(/:id(.:format))', :controller => 'admin/events', :action => 'hide'
  map.admin_event_publish '/admin/events/publish(/:id(.:format))', :controller => 'admin/events', :action => 'publish'
  map.admin_events_bulk_publish '/admin/events/bulk_publish((.:format))', :controller => 'admin/events', :action => 'bulk_publish'

  map.namespace :admin do |admin|
    admin.index '/', :controller => 'index', :action => 'index'
    admin.resources :organisations
    admin.resources :events 
  end

  map.resources :organisations, 
    :only => [:index, :show], 
    :member => { :star => :get, :unstar => :get }, 
    :collection => { :starred => :get }

  map.resources :events, 
      :only => [:index, :show], 
      :member => { :star => :get, :unstar => :get }, 
      :collection => { :starred => :get }
    
  # map.root            :controller => 'home'
  # map.about '/about', :controller => 'about'
  # map.admin '/admin', :controller => 'admin'

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "home"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
