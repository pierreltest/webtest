(function($) {
  // get the account menu
  var nav_selector = "#block-blurb-menu-blurby-account-menu-v4";

  var is_url_element = function(account_element) { return account_element.type == 'url'; };
  var is_image_element = function(account_element) { return account_element.type == 'url_with_css_image_hash'; };
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
    $(nav_selector + ' .utility__list-item--search form').attr('action', url);
  }

  $.ajax({
    url: 'http://www.blurb.com/api/v4/navigation/account_menu',
  })
    .done(function(resp) {
      if (resp.account_menu) {
        // add the account stuff
        var $list = $(nav_selector + ' ul'); 
        var forward_elements = _.chain(resp.account_menu)
            .filter(is_url_element)
            .map(menu_element)
            .reduce(url_menu_sum, '')
            .value();
        var backward_elements = _.chain(resp.account_menu)
            .filter(is_image_element)
            .map(menu_element)
            .reduce(url_menu_sum, '')
            .value();
        $list.prepend(forward_elements);
        $list.append(backward_elements);

        // update the search url
        var search_url = _.find(resp.account_menu, function(elem) { return elem.type == "search"; }).url;
        update_search_url(search_url);
      } else {
        console.log('something is wrong with the account menu response');
      }
    })
    .fail(function() {
      console.log('failed to get the account menu');
    });
})($)



