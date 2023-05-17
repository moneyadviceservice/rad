define(['jquery'], function($) {
  'use strict';

  var $form = $('[data-wizard-form] form.wizard-form'),
      $formItems = $form.find('[data-wizard-item]'),
      $submitButton = $form.find('[data-wizard-next-button]'),
      $prevButton = $form.find('[data-wizard-previous-button]'),
      $currentStep = $formItems.first(),
      $currentStepNumber = 0;

  addStepEventHandler($currentStep);

  $submitButton.on('click', function(e){
    e.preventDefault();

    if($formItems.length - 1 == $currentStepNumber){
      $form.submit();
    }else{
      $currentStep.addClass('hidden').removeClass('show show-previous');
      $currentStepNumber += 1;

      $currentStep = $($formItems[$currentStepNumber]);
      $currentStep.removeClass('hidden show-previous').addClass('show');
      addStepEventHandler($currentStep);
      disableOrEnableSubmitButton($currentStep);
    }
  });

  $prevButton.on('click', function(e){
    e.preventDefault();

    $currentStep.addClass('hidden').removeClass('show-previous show');
    $currentStepNumber -= 1;

    $currentStep = $($formItems[$currentStepNumber]);
    $currentStep.removeClass('hidden').addClass('show-previous');

    addStepEventHandler($currentStep);
    disableOrEnableSubmitButton($currentStep);
  });

  function addStepEventHandler(step){
    step.on('change', function(e){
      $submitButton.attr('disabled', false);
    });
  }

  function disableOrEnableSubmitButton(step){
    $submitButton.attr('disabled', step.find('input:checked').length <= 0);
    if($currentStepNumber > 0){
      $prevButton.css('display', 'inline-block');
    }else{
      $prevButton.css('display', 'none');
    }
  }
});
