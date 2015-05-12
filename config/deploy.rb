require "open-uri"
require "bundler/capistrano"
require 'esa_tasks/recipes/static_app'

# for static deploy
set :application, 'website'
set(:jenkins_job) { "#{application}-#{branch}" }
set(:artifact_name) { "#{application}.tar.gz" }

before 'website:deploy' do
  set :jenkins_host, "jenkins.blurb.com"
  set :artifact_number, "lastSuccessfulBuild" unless exists?(:artifact_number)
  set :artifact_job, "#{application}-#{branch}" unless exists?(:artifact_job)
  set :artifact_url, "http://#{jenkins_host}/job/#{artifact_job}/#{artifact_number}/artifact/#{artifact_name}" unless exists?(:artifact_url)
end

namespace :website do
  task :deploy, :roles => :web, :except => { :no_release => true } do
    static.update_code
    top.deploy.symlink
  end
end