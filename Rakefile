# Once we're on jekyll v2 we can move to using hooks
# http://jekyllrb.com/docs/plugins/#hooks
task :build => [:build_jekyll, :cp_pipeline_assets]

task :build_jekyll do
  `jekyll build`
end

task :cp_pipeline_assets => [:rewrite_css_urls] do
  `cp _site/assets/* _site/new-website-assets/`
  `cp _site/assets/* _site/de/new-website-assets/`
  `cp _site/assets/* _site/fr/new-website-assets/`
  `cp _site/assets/* _site/en-gb/new-website-assets/`
  `cp _site/assets/* _site/pt/new-website-assets/`
  `cp _site/assets/* _site/it/new-website-assets/`
  `cp _site/assets/* _site/nl/new-website-assets/`
  `cp _site/assets/* _site/es/new-website-assets/`
end

task :rewrite_css_urls do
  mac = RbConfig::CONFIG['host_os'].match(/darwin/)
  `sed -i #{ mac ? "''" : ''} 's/url\("../url\("\\/new-website-assets\\/bower\\/buildkit/g' _site/assets/*.css`
end
