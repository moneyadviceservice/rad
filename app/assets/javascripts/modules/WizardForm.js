define(['jquery'], function($) {
  'use strict';

  var $form = $('[data-wizard-form] form'),
      $formItems = $form.find('.wizard-form-item'),
      $submitButton = $form.find('button'),
      $currentStep = $formItems.first(),
      $currentStepNumber = 0;

  $formItems.hide().first().show();
  addStepEventHandler($currentStep)
  disableOrEnableSubmitButton($currentStep);

  $submitButton.on('click', function(e){
    e.preventDefault();

    if($formItems.length - 1 == $currentStepNumber){
      $form.submit();
    }else{
      $currentStep.slideToggle()
      $currentStepNumber += 1

      $currentStep = $($formItems[$currentStepNumber])
      $currentStep.slideToggle()
      addStepEventHandler($currentStep)
      disableOrEnableSubmitButton($currentStep);
    }
  })

  function addStepEventHandler(step){
    step.on('change', function(e){
      $submitButton.attr('disabled', false)
    })
  }

  function disableOrEnableSubmitButton(step){
    $submitButton.attr('disabled', step.find('input:checked').length <= 0)
  }
});
