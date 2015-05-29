require "jekyll-assets"

module Blurb
  class BuildkitFontGenerator < Jekyll::Generator
    safe true
    
    def generate(site)
      `cp _site/assets/* _site/new-website-assets/ 2>/dev/null`
      `sed -i '' 's/url\("../url\("\\/new-website-assets\\/bower\\/buildkit\\/assets/g' _site/new-website-assets/*.css`
    end
  end
end
