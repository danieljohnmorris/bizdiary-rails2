namespace :cothink do
  namespace :deploy do
    desc "Easy deploy!"
    task :deploy => :environment do
      `git checkout dev`
      `git pull origin dev`
      `git push origin dev`
      `git checkout master`
      `git pull origin master`
      `git merge dev`
      `git push origin master`
      `cap deploy:web:disable`
      `cap deploy`
      `cap deploy:web:enable`
      `git checkout dev`
    end
  end
end
