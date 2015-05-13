var Account;

Account = (function() {
  Account.prototype.path = '/api/v4/navigation/account_menu';

  function Account(_, $, domain) {
    this.domain = domain;
    this._ = _;
    this.$ = $;
    this.endpoint = this.domain + this.path;
  }

  Account.prototype.render = function(targetEl) {
    var is_url_element = function(account_element) { return account_element.type == 'url'; };
    var is_image_element = function(account_element) { return account_element.type == 'url_with_css_image_hash'; };
    var is_search_element = function(account_element) { return account_element.type == 'search'; };
    var social_element_type = function(klass) {
      if (klass == 'facebook-img') {
        return 'facebook';
      } else if (klass == 'google-plus-img') {
        return 'googleplus';
      } else if (klass == 'twitter-img') {
        return 'twitter';
      }
    }
    var url_menu_element = function(url, text) {
      return '<li class="utility__list-item  utility__list-item--show-lg utility__account-menu-item js-utility__account-menu-item"><a class="utility__cta" href="' + url + '">' + text + '</a></li>';
    }
    var image_menu_element = function(klass, url) {
      var type = social_element_type(klass);
      return '<li class="utility__list-item  utility__list-item--social  utility__list-item--show-lg"><a class="utility__cta" href="' + url + '"><span class="icon  social--utility--' + type  + '--blue"></span></a></li>';
    }
    var menu_element = function(account_element) {
      if (is_url_element(account_element)) {
        return url_menu_element(account_element.url, account_element.text);
      } else if (is_image_element(account_element)) {
        return image_menu_element(account_element.class, account_element.url);
      } else {
        return '';
      }
    }
    var url_menu_sum = function(memo, elem) { return memo + elem; };

    var update_search_url = function(url) {
      $(targetEl + ' .utility__list-item--search form').attr('action', url);
    }

    var update_account_menu = function(account_menu) {
      // add the account stuff
      var $list = $(targetEl + ' ul'); 
      var forward_elements = _.chain(account_menu)
          .filter(is_url_element)
          .map(menu_element)
          .reduce(url_menu_sum, '')
          .value();
      var backward_elements = _.chain(account_menu)
          .filter(is_image_element)
          .map(menu_element)
          .reduce(url_menu_sum, '')
          .value();
      $list.prepend(forward_elements);
      $list.append(backward_elements);
      
      // update the search url
      var search_url = _.find(account_menu, is_search_element).url;
      update_search_url(search_url);
    }

    $.ajax({
      url: 'http://www.blurb.com/api/v4/navigation/account_menu',
    })
      .done(function(resp) {
        if (resp.account_menu) {
          update_account_menu(resp.account_menu);
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
