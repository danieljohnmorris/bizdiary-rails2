server '173.203.95.138', :app, :web, :db, :primary => true

default_run_options[:pty] = true

### SEARCH - THINKING SPHINX 

# Thinking Sphinx
namespace :thinking_sphinx do
  task :configure, :roles => [:app] do
    run "cd #{current_path}; rake thinking_sphinx:configure RAILS_ENV=#{rails_env}"
  end
  task :index, :roles => [:app] do
    run "cd #{current_path}; rake thinking_sphinx:index RAILS_ENV=#{rails_env}"
  end
  task :start, :roles => [:app] do
    run "cd #{current_path}; rake thinking_sphinx:start RAILS_ENV=#{rails_env}"
  end
  task :stop, :roles => [:app] do
    run "cd #{current_path}; rake thinking_sphinx:stop RAILS_ENV=#{rails_env}"
  end
  task :restart, :roles => [:app] do
    run "cd #{current_path}; rake thinking_sphinx:restart RAILS_ENV=#{rails_env}"
  end
  task :rebuild, :roles => [:app] do
    run "cd #{current_path}; rake thinking_sphinx:rebuild RAILS_ENV=#{rails_env}"
  end
end

# Thinking Sphinx typing shortcuts
namespace :ts do
  task :conf, :roles => [:app] do
    run "cd #{current_path}; rake thinking_sphinx:configure RAILS_ENV=#{rails_env}"
  end
  task :in, :roles => [:app] do
    run "cd #{current_path}; rake thinking_sphinx:index RAILS_ENV=#{rails_env}"
  end
  task :start, :roles => [:app] do
    run "cd #{current_path}; rake thinking_sphinx:start RAILS_ENV=#{rails_env}"
  end
  task :stop, :roles => [:app] do
    run "cd #{current_path}; rake thinking_sphinx:stop RAILS_ENV=#{rails_env}"
  end
  task :restart, :roles => [:app] do
    run "cd #{current_path}; rake thinking_sphinx:restart RAILS_ENV=#{rails_env}"
  end
  task :rebuild, :roles => [:app] do
    run "cd #{current_path}; rake thinking_sphinx:rebuild RAILS_ENV=#{rails_env}"
  end
end

# http://github.com/jamis/capistrano/blob/master/lib/capistrano/recipes/deploy.rb
# :default -> update, restart
# :update  -> update_code, symlink
namespace :deploy do
  task :before_update_code do
    # Stop Thinking Sphinx before the update so it finds its configuration file.
    thinking_sphinx.stop
  end

  task :after_update_code do
    symlink_sphinx_indexes
    sudo "chown -R rails:rails #{current_path}/config" 
    thinking_sphinx.configure
    thinking_sphinx.start
  end

  desc "Link up Sphinx's indexes."
  task :symlink_sphinx_indexes, :roles => [:app] do
    run "ln -nfs #{shared_path}/db/sphinx #{current_path}/db/sphinx"
  end
end