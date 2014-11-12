require "open-uri"
require "bundler/capistrano"
require 'date'
require 'esa_tasks/recipes/seafile'

#require 'debugger'

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
end

namespace :quickbuild do
  task :deploy, :roles => [:drupal], :only => {:primary => true} do
    set :user, 'blurbapp'
    output = `set -e; bundle exec jekyll build; tar -czf quickbuild.tar.gz -C _site quickbuild;`
    puts(output)
    temp_name = DateTime.now.strftime("/tmp/quickbuild_%Y_%m_%d_%H%M%S.tar.gz")
    drupal_target = "/data/apps/drupal/current/drupal/sites/default/files/quickbuild"
    cmds = [
      "rm -rf /tmp/quickbuild",
      "tar -xzf #{temp_name} -C /tmp",
      "mkdir -p #{drupal_target}",
      "cp -f /tmp/quickbuild/* #{drupal_target}"
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
    deploy_images
  end

  desc 'Deploy quickbuild images from seafile'
  task :deploy_images do
    seafile.sync
  end
end
