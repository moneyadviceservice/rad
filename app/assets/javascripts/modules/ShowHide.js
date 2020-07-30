define(['jquery'], function($) {
  'use strict';

  // Initial state
  $('[data-show-hide]:checked').each(function(){
    var target = $('['+$(this).data('show-hide')+']'),
        triggerValue =$(this).data('show-hide-trigger') || 0;

    if($(this).val() == triggerValue){
      target.hide()
    }
  })

  $('[data-show-hide]').on('change', function(){
    var target = $('['+$(this).data('show-hide')+']'),
        triggerValue =$(this).data('show-hide-trigger') || 0;

    if($(this).val() == triggerValue){
      target.slideUp()
    }else{
      target.slideDown()
    }
  })
});
