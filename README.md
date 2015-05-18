# Blurb.com Website

Static site generator for CMS page layouts.

## For Content Creators

## Pre-reqs

Download the [github client](https://mac.github.com).

## Getting the code

1. Go to https://github.com/blurb/website
2. Create a fork by clicking on "Fork"
3. Once the fork is created, click on "Clone in Desktop" link
4. Follow the instructions

For more information on the Fork and Pull model used here please check https://help.github.com/articles/using-pull-requests/

## Adding a Page

1. Create a new file in [website folder]/pages, let's call it "new-page.html"
2. In the [front-matter](https://github.com/blurb/website/blob/cd7b0bd7fb5926362ed846c67b946e2582a6be91/pages/amazon-and-more.html#L1-L7) add "draft: true" (this will ensure the new page starts as a draft).
3. Add your content. See [Using modules](#using-modules) and [Creating content outside of modules](#creating-content-outside-of-modules) for different ways of adding content.

## Committing a page

After you've created and saved your page you're going to want to push it up and watch it get deployed.

1. Open Github (which you downloaded in [Getting the code](#getting-the-code))
2. Create a new branch (for example, "adding-new-page")
2. You should see a summary of your changes, just write a summary and description of the changes and press "commit to adding-new-page"
3. Press "Publish" on the top right
4. Go to your fork and click on "Compare & pull request"
5. When you've added a proper description and summary click on "Create pull request"
6. Once gengo has translated everything (and maybe you've run it by some peers) you can click on "Merge pull request"
7. Check [the master build](http://jenkins.blurb.com/job/website-master/) and then [the master deploy job](http://jenkins.blurb.com/job/website-master-deploy/)
8. Once each job has finished you should be able to go to master.eng.blurb.com/drafts/[name of your page]
9. If all looks good you're welcome to remove the `draft: true`, commit and sync with master, wait for [the master build](http://jenkins.blurb.com/job/website-master/), and then build [the production deploy job](http://jenkins.blurb.com/job/website-production-deploy/)

Once done your new page should be visible on the production website.

### Using modules

We've created a list of modules to easily add content to structured data. Please see the [modules folder](https://github.com/blurb/website/tree/master/pages/_includes/modules) for all the modules. Each module should have sufficient documentation. Please see [the amazon and more page](https://github.com/blurb/website/blob/a3c0ee9e4e72a10d0ab00efa04252410436144aa/pages/amazon-and-more.html) for an example of their use. You can also refer to the [buildkit modules](http://buildkit.eng.blurb.com/documentation/modules/) for a list of all possible modules. If a module hasn't been added to the website yet please see [Pierre](plarochelle@blurb.com).

### Creating content outside of modules

If you want to add generic html please remember to wrap the content in "tb" tags. Look at the [amazon and more](https://github.com/blurb/website/blob/a3c0ee9e4e72a10d0ab00efa04252410436144aa/pages/amazon-and-more.html#L13-L23) page for a good example. Any non-module content not wrapped in these tags will not be translated.

## For Web Developers

### Pre-reqs
1. install [node](https://nodejs.org/)
2. install [npm](https://www.npmjs.com/)
3. install [bower](http://bower.io/)
4. install [bundler](http://bundler.io/) (usually doing `rbenv exec install bunder` from within this dir works)
5. add `0.0.0.0 website.blurb.com` to the end of your /etc/hosts file (for x-origin support - not a hard req)

### Running
    $ bundle install
    $ bower install
    $ bundle exec jekyll serve
    $ open http://website.blurb.com:4000/amazon-and-more.en.html # just an example for now

### Building
    $ bundle install
    $ bower install
    $ bundle exec jekyll build # and the result will be in ./_site
