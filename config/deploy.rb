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

set :shared_host, "thebusinessdiary.co.uk"
namespace :update do
  desc "Mirrors the remote shared public directory with your local copy, doesn't download symlinks"
  task :shared_assets do
    if shared_host
      # Used friendly options so it's easier to read
      # I'm using rsync so that it only copies what it needs
      # Windows users you can use the download method within capistrano and pass recursive =&gt; true
      run_locally("rsync --recursive --times --rsh=ssh --compress --human-readable --progress #{user}@#{shared_host}:#{shared_path}/public/ public/")
    else
      puts "Ummmm. You should define a shared_host variable so I know where to get the files from."
    end
  end
 
  desc "Dump remote production database into tmp/, rsync file to local machine, import into local development database"
  task :database do
    # First lets get the remote database config file so that we can read in the database settings
    get("#{shared_path}/config/database.yml", "tmp/database.yml")
 
    # load the production settings within the database file
    remote_settings = YAML::load_file("tmp/database.yml")["production"]
 
    # we also need the local settings so that we can import the fresh database properly
    local_settings = YAML::load_file("config/database.yml")["development"]
 
    # dump the production database and store it in the current path's tmp directory. I chose to use the same filename everytime so that it would just overwrite the same file rather than creating a timestamped file.  If you want to use this to create backups then I would recommend putting something like Time.now in the filename and not storing it in the tmp directory
    #run "mysqldump -u'#{remote_settings["username"]}' -p'#{remote_settings["password"]}' -h'#{remote_settings["host"]}' '#{remote_settings["database"]}' > #{current_path}/tmp/production-#{remote_settings["database"]}-dump.sql"
    run "mysqldump -u 'root' '#{remote_settings["database"]}' > #{shared_path}/db/production-#{remote_settings["database"]}-dump.sql"
  # If your database is large you might want to bzip it up and then extract it later
 
    # run_locally is a method provided by capistrano to run commands on your local machine. Here we are just rsyncing the remote database dump with the local copy of the dump
    run_locally("rsync --times --rsh=ssh --compress --human-readable --progress #{user}@#{shared_host}:#{shared_path}/db/production-#{remote_settings["database"]}-dump.sql tmp/production-#{remote_settings["database"]}-dump.sql")
 
    # now that we have the upated production dump file we should use the local settings to import this db.
    run_locally("mysql -u#{local_settings["username"]} #{"-p#{local_settings["password"]}" if local_settings["password"]} #{local_settings["database"]} < tmp/production-#{remote_settings["database"]}-dump.sql")
  end
end