require "open-uri"
require "bundler/capistrano"
require 'esa_tasks/recipes/static_app'

# for static deploy
set :application, 'website'
set(:jenkins_job) { "#{application}-Artifact" }
set(:artifact_name) { "#{application}.tar.gz" }
set(:artifact_url) { jenkins_build_artifact_urls.find { |u| u =~ /#{artifact_name}$/ } }

namespace :deploy do
  task :update_code, :except => { :no_release => true } do
    transaction do
      on_rollback { run "rm -rf #{release_path}; true" }
      artifact = File.basename(artifact_url)
      runCommands <<-UPDATE_CODE
        mkdir -p #{release_path}
        cd #{release_path}
        wget -q #{artifact_url} -O #{artifact}
        tar zxf #{artifact} --warning=none
        rm -f #{artifact}
      UPDATE_CODE
    end
  end
end
