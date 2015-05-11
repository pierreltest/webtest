require "open-uri"
require "bundler/capistrano"
require 'date'
require 'esa_tasks/recipes/seafile'

# for static deploy
set :application, 'website'
set :jenkins_job, 'website-Artifact'
set :artifact_name, 'website.tar.gz'
set (:artifact_url) { jenkins_build_artifact_urls.find { |u| u =~ /#{artifact_name}$/ } }


load :string => Kernel.open("#{fetch(:bud_root, 'http://repo.blurb.com/bud')}/config/deploycommon.rb", 'r', &:read)

# quickbuild images are deployed under /data/drupal/quickbuild_images/contents
set :seafile_deploy_root, '/data/drupal/quickbuild_images'
set :seafile_library, 'quickbuild_images'
role(:seafile) do
  find_servers(:roles => :drupal, :only => {:primary => true})
end

namespace :deploy do
  task :default do
    raise("Don't call this! Use quickbuild:deploy")
  end
  
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

namespace :quickbuild do
  task :deploy, :roles => [:drupal], :only => {:primary => true} do
    set :user, fetch(:user, 'blurbapp')
    output = `set -e; bundle exec jekyll build; tar -czf quickbuild.tar.gz -C _site quickbuild;`
    puts(output)
    temp_name = DateTime.now.strftime("/tmp/quickbuild_%Y_%m_%d_%H%M%S.tar.gz")
    drupal_target = "/data/apps/drupal/current/drupal/sites/default/files/quickbuild"
    cmds = [
      "rm -rf /tmp/quickbuild",
      "tar -xzf #{temp_name} -C /tmp",
      "mkdir -p #{drupal_target}",
      "rsync -avz --delete #{fetch(:quickbuild_rsync_args, '')} /tmp/quickbuild/ #{drupal_target}"
      ]
    begin
      upload("quickbuild.tar.gz", temp_name)
      cmds.each do |cmd|
      run("set -e; #{cmd}") do |channel, stream, data|
        logger.info( "[#{stream} :: #{channel[:host]}] #{data}")
      end
      end
    ensure
      run("rm -f #{temp_name}; rm -rf /tmp/quickbuild")
    end
    if fetch(:deploy_images,false)
      deploy_images
      run "if [ -d /data/drupal/buildkit ]; then rm -rf /data/drupal/buildkit; fi && ln -fs #{seafile_deploy_root}/contents /data/drupal/buildkit"
      run "if [ -d /data/apps/drupal/current/drupal/sites/default/files ]; then ln -sf #{seafile_deploy_root}/contents /data/apps/drupal/current/drupal/sites/default/files/buildkit; fi"
    end
  end

  desc 'Deploy quickbuild images from seafile'
  task :deploy_images do
    seafile.sync
  end
end
