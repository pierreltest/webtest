(function($) {
  // get the account menu
  var nav_selector = "#block-blurb-menu-blurby-account-menu-v4";

  var is_url_element = function(account_element) { return account_element.type == 'url'; };
  var is_image_element = function(account_element) { return account_element.type == 'url_with_css_image_hash'; };
  var url_menu_element = function(url, text) {
    return '<li class="utility__list-item  utility__list-item--show-lg utility__account-menu-item js-utility__account-menu-item"><a class="utility__cta" href="' + url + '">' + text + '</a></li>';
  }
  var image_menu_element = function(klass, url) {
    return '';
  }
  var menu_element = function(account_element) {
    if (is_url_element(account_element)) {
      return url_menu_element(account_element.url, account_element.text);
    } else if (is_image_element(account_element)) {
      return image_menu_element(account_element.klass, account_element.url);
    } else {
      return '';
    }
  }
  var url_menu_sum = function(memo, elem) { return memo + elem; };

  $.ajax({
    url: 'http://www.blurb.com/api/v4/navigation/account_menu',
  })
    .done(function(resp) {
      if (resp.account_menu) {
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
      } else {
        console.log('something is wrong with the account menu response');
      }
    })
    .fail(function() {
      console.log('failed to get the account menu');
    });
})($)



