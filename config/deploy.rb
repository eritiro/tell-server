require "bundler/capistrano"
require "rvm/capistrano"  # Load RVM's capistrano plugin.

set :rvm_type, :system
set :rvm_path, "/usr/local/rvm"
set :rvm_ruby_string, "ruby-2.1.2"
set :application, "tell-server"

set :repository, "git@bitbucket.org:eritiro/tell-server.git"
set :branch, "master"
set :scm, "git"
set :user, "deployer"
set :deploy_via, :remote_cache

server "tell.startmeapps.com", :app, :web, :db, :primary => true
set :deploy_to, '/deployment/tell-server'

# keeps track of the last 5 releases
set :keep_releases, 5
after "deploy:restart", "deploy:cleanup"

# creates dirs, if it's needed
before "deploy", "deploy:setup"

#always migrates the database
after 'deploy:update_code', 'deploy:migrate'

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end

set :user, "ubuntu" # you could even do `set :user, application` here
set :use_sudo, false

ssh_options[:keys] = [File.join(ENV["HOME"], ".certs", "startmeapps.pem")]

# Generate an additional task to fire up the thin clusters
namespace :deploy do
  desc "Start the Thin processes"
  task :start do
    run  <<-CMD
      cd /deployment/tell-server/current; bundle exec thin start -C config/thin.yml
    CMD
  end

  desc "Stop the Thin processes"
  task :stop do
    run <<-CMD
      cd /deployment/tell-server/current; bundle exec thin stop -C config/thin.yml
    CMD
  end

  desc "Restart the Thin processes"
  task :restart do
    run <<-CMD
      cd /deployment/tell-server/current; bundle exec thin restart -C config/thin.yml
    CMD
  end
end

load 'lib/deploy/seed'