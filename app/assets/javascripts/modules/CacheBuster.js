define(['jquery'], function($) {
  'use strict';

  var bustCache = $('.travel-registration-form').length;

  if(bustCache > 0){
    window.onpageshow = function(event) {
      if (event.persisted) {
        window.location.reload();
      }
    };
  }
});
