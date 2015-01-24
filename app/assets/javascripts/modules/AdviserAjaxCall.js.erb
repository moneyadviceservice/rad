define(['jquery'], function($) {

  'use strict';

  var $inputField = $('[data-input]');

  $inputField.keyup(function(){

    var $success = $('[data-notice="success"]'),
        $error = $('[data-notice="error"]'),
        $inputFieldValue = $(this).val(),

        // constructs the URL to retrieve the FCA Adviser name
        url = $(this).attr('data-url') + $inputFieldValue + ".json",

        error404 = "<p>We cannot find that adviser. Please try entering the reference number again.</p>",
        error500 = "<p>The server is not responding. We are unable to check whether that individual reference number is valid. Please try again later.</p>";

    $.ajax(url, {
      datatype: 'json',
      contentType: 'application/json',

      success: function(result) {
        $success.html("<p>" + result.name + "</p>");
        $success.removeClass('is-hidden');
        $error.addClass('is-hidden');
      },

      error: function(request) {
        $error.removeClass('is-hidden');
        $success.addClass('is-hidden');
      },

      statusCode: {
        404: function() {
          $error.html(error404);
        },

        500: function() {
          $error.html(error500);
        }
      }
    });
  });
});
