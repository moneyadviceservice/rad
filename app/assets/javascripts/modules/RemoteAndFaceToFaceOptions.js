define(['jquery'], function($) {
  'use strict';

  var $picker = $('[data-remote-and-face-to-face-picker]'),
      $fieldset = $('[data-remote-and-face-to-face-conditional-fieldset]');

  if($picker.find(':checked').length === 0) {
    $fieldset.hide();
    $picker.change(function() {
      $fieldset.show();
    });
  }
});
