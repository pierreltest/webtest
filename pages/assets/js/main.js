(function($, _) {
  // set up the domain
  var blurblocation = BlurbLocation();
  var subdomain = blurblocation.baseSubdomain,
      domain;

  if (subdomain == "website") {
    domain = 'master.eng.blurb.com';
  } else {
    domain = subdomain + '.blurb.com';
  }

  // set up the account nav
  var account = new BlurbWebsite.Account(_, $, domain);
  account.render('#block-blurb-menu-blurby-account-menu-v4');
})($, _)



