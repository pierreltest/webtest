this.Blurb || (this.Blurb = {});

(function($, _) {
  // set up the domain
  var blurblocation = BlurbLocation();
  var subdomain = blurblocation.baseSubdomain,
      domain;

  if (subdomain == "website") {
    domain = 'master.eng.blurb.com';
  } else if (subdomain == "prod") {
    domain = "www.blurb.com";
  } else {
    domain = subdomain + '.blurb.' + blurblocation.domainSuffix;
  }

  // set up the account nav
  var account = new BlurbWebsite.Account(_, $, domain);
  account.render('#block-blurb-menu-blurby-account-menu-v4');

  // set up the locale
  Blurb.locale = blurblocation.locale.split('_')[0];
})($, _)



