# Blurb.com Website

Static site generator for CMS page layouts.

## Pre-reqs
1. install [node](https://nodejs.org/)
2. install [npm](https://www.npmjs.com/)
3. install [bower](http://bower.io/)
4. install [bundler](http://bundler.io/) (usually doing `rbenv exec install bunder` from within this dir works)
5. add `0.0.0.0 website.blurb.com` to the end of your /etc/hosts file (for x-origin support - not a hard req)

## Running
    $ bundle install
    $ bower install
    $ bundle exec jekyll serve
    $ open http://website.blurb.com:4000/amazon-and-more.en.html # just an example for now

# Building
    $ bundle install
    $ bower install
    $ bundle exec jekyll build # and the result will be in ./_site
