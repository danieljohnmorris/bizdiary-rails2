namespace :bizdiary do
  
  desc "Send email reminders"
  task :send_reminders => :environment do
    
    
    
  end
  
  desc "Import from YAML"
  task :import => :environment do
    require 'yaml'
    Importer.import_event_vos YAML.load(STDIN.read)
  end
  
  desc "Run scrapers and import"
  task :run_scrapers_and_import do
    
    scraper_dir = ARGV[1].gsub(/\/$/,'')
    
    bin = scraper_dir + '/bin/grater'
    
    raise "Can't find grater exec at #{bin}" unless File.exist?(bin)
    
    cmd = "#{bin} " + ["config/config.yml", *Dir.glob(scraper_dir + '/config/scrapers/*')].join(' ')
    p cmd
    
  end
  
end