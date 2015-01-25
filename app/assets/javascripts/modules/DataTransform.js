define(['jquery'], function($) {

  'use strict';

  var $inputField = $('[data-transform]');

  $inputField.keyup(function() {
    var $this = $(this);

    $this.val($this.val().toUpperCase());
  });
});
