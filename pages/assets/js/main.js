(function($, _) {
  var hostname = function() {
    var blurblocation = BlurbLocation();
    var subdomain = blurblocation.subdomain.replace(/-static/, '');

    if (subdomain == "website") {
      return 'master.eng.blurb.com';
    } else {
      return subdomain + '.blurb.com';
    }
  }

  
  var account = new BlurbWebsite.Account(_, $, hostname());
  account.render('#block-blurb-menu-blurby-account-menu-v4');
})($, _)



