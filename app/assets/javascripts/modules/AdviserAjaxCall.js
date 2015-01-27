define(['jquery'], function($) {

  'use strict';

  var $inputField = $('[data-input]');

  $inputField.keyup(function(){

    var $success = $('[data-notice="success"]'),
        $error = $('[data-notice="error"]'),
        $inputFieldValue = $(this).val(),
        url = $(this).attr('data-url') + $inputFieldValue + ".json",
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
        404: function(request) {
          $error.html("<p>" + request.responseJSON.error + "</p>");
        },

        409: function(request) {
          $error.html("<p>" + request.responseJSON.error + "</p>");
        },

        500: function(request) {
          $error.html(error500);
        }
      }
    });
  });
});
