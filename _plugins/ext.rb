require "jekyll-assets"

module Blurb
  class BuildkitFontGenerator < Jekyll::Generator
    safe true
    
    def generate(site)
      `rm -rf _site/fonts`
      `cp -R pages/new-website-assets/bower/buildkit/assets/fonts _site/fonts`
    end
  end
end
