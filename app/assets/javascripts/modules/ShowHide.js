define(['jquery'], function($) {
  'use strict';

  // Initial state
  $('[data-show-hide]').each(function(){
    var target = $('['+$(this).data('show-hide')+']'),
        otherInputs = $('[data-show-hide='+$(this).data('show-hide')+']'),
        checked_inputs = otherInputs.filter(':checked');

    if(checked_inputs.length == 0 || checked_inputs.first().val() != checked_inputs.first().data('show-hide-trigger')){
      target.hide()
    }
  })

  $('[data-show-hide]').on('change', function(){
    var target = $('['+$(this).data('show-hide')+']'),
        triggerValue = $(this).data('show-hide-trigger') || 0;

    if($(this).val() != triggerValue){
      target.slideUp()
    }else{
      target.slideDown()
    }
  })
});
