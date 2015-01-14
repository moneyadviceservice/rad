define(['jquery'], function($) {

  'use strict';

  var targetElement = $("[data-target='hide']"),
      triggerElement = $("[data-trigger='toggle-show-hide']");

  // hide the element on page load
  targetElement.addClass('is-hidden');

  // toggle visibility for the element if radio button is checked
  $('input:radio').on('click', function() {
    if ( triggerElement.is(':checked') ) {
      targetElement.removeClass('is-hidden');
    } else {
      targetElement.addClass('is-hidden');
    }
  });
});