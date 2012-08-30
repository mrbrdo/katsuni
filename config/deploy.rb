set :application, "site"
set :repository,  "git@bitbucket.org:user/katsuni.git"

set :deploy_to, "/home/user/site.org"

set :user, 'user'
set :runner, 'user'
set :use_sudo, false
set :ssh_options, { :forward_agent => true }

set :scm, :git
set :deploy_via, :remote_cache
set :branch, "master"

# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "site.org"                          # Your HTTP server, Apache/etc
role :app, "site.org"                          # This may be the same as your `Web` server
role :db,  "site.org", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

ssh_options[:paranoid] = false

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end
