set :user, 'dev'
set :domain, 'jubilee-linux-box'
set :application, 'green_game'

set :repository,  "#{user}@#{domain}:git/#{application}.git"
set :deploy_to, "/home/#{user}/Desktop/Work/Ruby/green_game_dev"

role :app, domain                          # This may be the same as your `Web` server
role :web, domain                          # Your HTTP server, Apache/etc
role :db,  domain, :primary => true        # This is where Rails migrations will run

set :deploy_via, :remote_cache
set :scm, :git
set :branch, 'master'
set :scm_verbose, true
set :use_sudo, false


# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

namespace :deploy do
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
end
