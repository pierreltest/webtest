var Account;
var something;
Account = (function() {
  Account.prototype.path = '/api/v4/navigation/account_menu';

  function Account(_, $, domain) {
    this.domain = domain;
    this._ = _;
    this.$ = $;
    this.endpoint = document.location.protocol + '//' + this.domain + this.path;
  }

  Account.prototype.render = function(targetEl) {
    var isUrlElement = function(accountElement) { return accountElement.type == 'url'; };
    var isImageElement = function(accountElement) { return accountElement.type == 'url_with_css_image_hash'; };
    var isSearchElement = function(accountElement) { return accountElement.type == 'search'; };
    var socialElementType = function(klass) {
      if (klass == 'facebook-img') {
        return 'facebook';
      } else if (klass == 'google-plus-img') {
        return 'googleplus';
      } else if (klass == 'twitter-img') {
        return 'twitter';
      }
    }
    var urlMenuElement = function(url, text) {
      return '<li class="utility__list-item  utility__list-item--show-lg utility__account-menu-item js-utility__account-menu-item"><a class="utility__cta" href="' + url + '">' + text + '</a></li>';
    }
    var imageMenuElement = function(klass, url) {
      var type = socialElementType(klass);
      return '<li class="utility__list-item  utility__list-item--social  utility__list-item--show-lg"><a class="utility__cta" href="' + url + '"><span class="icon  social--utility--' + type  + '--blue"></span></a></li>';
    }
    var menuElement = function(accountElement) {
      if (isUrlElement(accountElement)) {
        return urlMenuElement(accountElement.url, accountElement.text);
      } else if (isImageElement(accountElement)) {
        return imageMenuElement(accountElement.class, accountElement.url);
      } else {
        return '';
      }
    }
    var urlMenuSum = function(memo, elem) { return memo + elem; };

    var updateSearchUrl = function(url) {
      $(targetEl + ' .utility__list-item--search form').attr('action', url);
    }

    var updateAccountMenu = function(accountMenu) {
      // add the account stuff
      var $list = $(targetEl + ' ul'); 
      var forwardElements = _.chain(accountMenu)
          .filter(isUrlElement)
          .map(menuElement)
          .reduce(urlMenuSum, '')
          .value();
      var backwardElements = _.chain(accountMenu)
          .filter(isImageElement)
          .map(menuElement)
          .reduce(urlMenuSum, '')
          .value();
      var searchUrl = _.find(accountMenu, isSearchElement).url;

      $list.prepend(forwardElements);
      $list.append(backwardElements);
      updateSearchUrl(searchUrl);
    }

    $.ajax({
      url: this.endpoint ,
    })
      .done(function(resp) {
        if (resp.account_menu) {
          updateAccountMenu(resp.account_menu);
        } else {
          console.log('something is wrong with the account menu response');
        }
      })
      .fail(function() {
        console.log('failed to get the account menu');
      })
  }

  return Account;
})();

this.BlurbWebsite || (this.BlurbWebsite = {});

this.BlurbWebsite.Account = Account;
