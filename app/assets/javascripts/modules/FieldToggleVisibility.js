/**
 * # Element visibility toggler.
 *
 * Requires an element to have a data-dough-component="FieldToggleVisibility" attribute. The application
 * file will spawn an instance of this class for each element it finds on the page.
 *
 * See test fixture for sample markup - /spec/js/fixtures/ToggleVisibility.html
 */

/**
 * Require from Config
 * @param  {[type]} $         [description]
 * @param  {[type]} DoughBaseComponent [description]
 * @return {[type]}           [description]
 * @private
 */
define(['jquery', 'DoughBaseComponent'], function($, DoughBaseComponent) {

  'use strict';

  var FieldToggleVisibilityProto,
      defaultConfig = {};

  function FieldToggleVisibility($el, config) {
    FieldToggleVisibility.baseConstructor.call(this, $el, config, defaultConfig);

    this.$triggers = this.$el.find('[data-dough-field-show],[data-dough-field-hide]');
    this.$targets = this.$el.find('[data-dough-field-target]');

    this.hideRelevantTargets();
  }

  /**
   * Inherit from base module, for shared methods and interface
   * @type {[type]}
   * @private
   */
  DoughBaseComponent.extend(FieldToggleVisibility);
  FieldToggleVisibilityProto = FieldToggleVisibility.prototype;

  /**
   * Init function
   *
   * Set up listeners and accept promise
   *
   * TODO: Clean up
   *
   * @param  {[type]} initialised [description]
   * @return {[type]}             [description]
   */
  FieldToggleVisibilityProto.init = function(initialised) {
    var self = this;

    self.$triggers.on('change', function(i, o) {
      var $trigger = $(this),
          actions = self.getActionsFromTrigger($trigger);

      $.each(actions, function(i, action) {
        self.onChange.call(self, $trigger, action.target, action.action);
      });
    });

    this._initialisedSuccess(initialised);

    return this;
  };

  FieldToggleVisibilityProto.hideRelevantTargets = function() {
    var self = this;

    this.$triggers.filter('[data-dough-field-show]:not(:checked)').each(function() {
      var $trigger = $(this),
        target = $trigger.attr('data-dough-field-show'),
        $target = self.$targets.filter('[data-dough-field-target="' + target + '"]');

        $target.addClass('is-hidden');
    });

    return this;
  };

  FieldToggleVisibilityProto.onChange = function($trigger, triggerTarget, triggerAction) {
    var $target = this.$el.find('[data-dough-field-target="' + triggerTarget + '"]');
    $target[triggerAction === 'show' ? 'removeClass' : 'addClass']('is-hidden');

    return this;
  };

  FieldToggleVisibilityProto.getActionsFromTrigger = function($trigger) {
    var actions = [];

    if ($trigger.is('[data-dough-field-show]')) {
      actions.push({action: 'show', target: $trigger.attr('data-dough-field-show')});
    }

    if ($trigger.is('[data-dough-field-hide]')) {
      actions.push({action: 'hide', target: $trigger.attr('data-dough-field-hide')});
    }

    return actions;
  };

  return FieldToggleVisibility;
});
