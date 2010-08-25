ActionController::Routing::Routes.draw do |map|
  map.devise_for :admins
  map.devise_for :people
  map.devise_for :organisations
  
  map.connect 'sitemap.xml', :controller => "sitemap", :action => "sitemap" 
  map.connect '/admin/events/ingest', :controller => 'admin/events', :action => 'ingest'
  map.claim_org '/organisations/claim', :controller => 'organisations', :action => 'claim'

  map.resources :organisations, 
    :member => { 
      :star => :get, 
      :unstar => :get 
    }, 
    :collection => { :starred => :get } do |org|      
    org.resources :events, 
      :member => { 
        :publish => :get, 
        :hide => :get
      },
      :collection => { 
        :bulk_publish => :get
      }
  end

  map.namespace :admin do |admin|
    admin.index '/', :controller => 'index', :action => 'index'
    admin.resources :organisations
    admin.resources :events,
      :member => { 
        :publish => :get, 
        :hide => :get
      },
      :collection => { 
        :bulk_publish => :get
      }
  end

  map.resources :events, 
      :only => [:index, :show],
      :member => { 
        :star => :get, 
        :unstar => :get 
      }, 
      :collection => { :starred => :get, :search => :get, :filter => :get}

  map.root :controller => "home"
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
