(function($) {
  // get the account menu
  var nav_selector = "#block-blurb-menu-blurby-account-menu-v4";
  var url_menu_element = function(account_element) {
    var url = account_element.url;
    var text = account_element.text;
    
    return '<li class="utility__list-item  utility__list-item--show-lg utility__account-menu-item js-utility__account-menu-item"><a class="utility__cta" href="' + url + '">' + text + '</a></li>';
  }

  var url_menu_sum = function(memo, elem) { return memo + elem; };

  $.ajax({
    url: 'http://www.blurb.com/api/v4/navigation/account_menu',
  })
    .done(function(resp) {
      if (resp.account_menu) {
        var elems = _.chain(resp.account_menu)
            .map(url_menu_element)
            .reduce(url_menu_sum, '')
            .value();
        $(nav_selector + ' ul').append(elems);
      } else {
        console.log('something is wrong with the account menu response');
      }
    })
    .fail(function() {
      console.log('failed to get the account menu');
    });
})($)



