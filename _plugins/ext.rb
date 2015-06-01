require "jekyll-assets"

module Blurb
  class BuildkitFontGenerator < Jekyll::Generator
    safe true
    
    def generate(site)
      mac = RbConfig::CONFIG['host_os'].match(/darwin/)
      `cp _site/assets/* _site/new-website-assets/ 2>/dev/null`
      `sed -i #{ mac ? "''" : ''} 's/url\("../url\("\\/new-website-assets\\/bower\\/buildkit/g' _site/new-website-assets/*.css`
    end
  end
end
