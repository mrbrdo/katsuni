load 'deploy'
require "bundler/capistrano"
load 'deploy/assets'
# Uncomment if you are using Rails' asset pipeline
    # load 'deploy/assets'
Dir['vendor/gems/*/recipes/*.rb','vendor/plugins/*/recipes/*.rb'].each { |plugin| load(plugin) }
load 'config/deploy' # remove this line to skip loading any of the default tasks

set :rvm_ruby_string, 'ruby-1.9.3-p194'
require "rvm/capistrano"