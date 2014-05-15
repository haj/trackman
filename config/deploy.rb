require "rvm/capistrano"
require 'bundler/capistrano'


set :user, 'demo'
set :domain, '198.199.108.58'
set :applicationdir, "/home/demo/trackman"

#git remote add ocean ssh://demo@198.199.108.58/~/trackman.git
 
set :scm, 'git'
set :repository,  "ssh://demo@198.199.108.58/~/trackman.git"
set :git_enable_submodules, 1 # if you have vendored rails
set :branch, 'master'
set :git_shallow_clone, 1
set :scm_verbose, true
set :ssh_options, { :forward_agent => true }

# Add RVM's lib directory to the load path.
$:.unshift(File.expand_path('./lib', ENV['rvm_path']))

set :rvm_ruby_string, 'ruby-2.0.0-p247'
set :rvm_type, :user  # Don't use system-wide RVM

#before :deploy, 'rvm:install_rvm'  # install/update RVM
#before :deploy, 'rvm:install_ruby' # install Ruby and create gemset
 
# roles (servers) 

role :web, domain
role :app, domain
role :db,  domain, :primary => true
 
# deploy config
set :deploy_to, applicationdir
set :deploy_via, :remote_cache #previously :copy
 
# additional settings
default_run_options[:pty] = true  # Forgo errors when deploying from windows
#ssh_options[:keys] = %w(/home/user/.ssh/id_rsa)            # If you are using ssh_keysset :chmod755, "app config db lib public vendor script script/* public/disp*"set :use_sudo, false
ssh_options[:forward_agent] = true

# Passenger
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end
