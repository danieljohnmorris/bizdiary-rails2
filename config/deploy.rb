server '173.203.95.138', :app, :web, :db, :primary => true

### SEARCH - THINKING SPHINX 

require 'vendor/plugins/thinking-sphinx/recipes/thinking_sphinx'

task :before_update_code, :roles => [:app] do
  thinking_sphinx.stop
end

task :after_update_code, :roles => [:app] do
  symlink_sphinx_indexes
  thinking_sphinx.configure
  thinking_sphinx.start
end

task :symlink_sphinx_indexes, :roles => [:app] do
  run "ln -nfs #{shared_path}/db/sphinx #{release_path}/db/sphinx"
end
