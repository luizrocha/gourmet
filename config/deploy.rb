#######################################################
#	Application				      #
#######################################################

set :application, 'gourmet'
set :deploy_to, '/home/luiz/rails/gourmet.bistrodavilla.com.br'


#######################################################
#	Settings				      #
#######################################################

default_run_options[:pty] = true
set :use_sudo, false
set :deploy_via, :remote_cache


#######################################################
#	Servers					      #
#######################################################
set :user, 'luiz'
set :domain, 'tomada.us:47132'
role :app, domain
role :web, domain
role :db, domain, :primary => true


#######################################################
#	GIT					      #
#######################################################
set :repository,  'git@github.com:luizrocha/gourmet.git'
set :scm, 'git'
set :branch, 'master'
set :scm_verbose, true


#######################################################
#	Passenger				      #
#######################################################
namespace :passenger do
  desc "Restart Application"
  task :restart do
	run 'touch /home/luiz/rails/gourmet.bistrodavilla.com.br/current/tmp/restart.txt'
  end
end

desc "copy database.yml into the current release path"
task :configure_database, :roles => :app do
  db_config = "#{deploy_to}/config/database.yml"
  run "cp #{db_config} #{release_path}/config/database.yml"
end

#######################################################
#	Actions					      #
#######################################################
#Avoid database.yml in GIT repository
after "deploy:update_code", :configure_database

#Restart App
after :deploy, 'passenger:restart'
