define(['jquery'], function($) {
  'use strict';

  // Initial state
  $('[data-show-hide]:checked').each(function(){
    var target = $('['+$(this).data('show-hide')+']')
    if($(this).val() == 0){
      target.hide()
    }
  })

  $('[data-show-hide]').on('change', function(){
    var target = $('['+$(this).data('show-hide')+']')
    if($(this).val() == 0){
      target.slideUp()
    }else{
      target.slideDown()
    }
  })
});
