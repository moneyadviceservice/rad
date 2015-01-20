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

    this.$triggers = this.$el.find('[data-dough-field-trigger]');
    this.$targets = this.$el.find('[data-dough-field-target]');

    if (!this.$triggers.filter('[data-dough-field-trigger-type="show"]').is(':checked')) {
      this.$targets.addClass('is-hidden');
    }
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
          triggerTarget = $trigger.attr('data-dough-field-trigger'),
          triggerAction = $trigger.attr('data-dough-field-trigger-type');

      self.onChange.call(self, $trigger, triggerTarget, triggerAction);
    });

    this._initialisedSuccess(initialised);

    return this;
  }

  FieldToggleVisibilityProto.onChange = function($trigger, triggerTarget, triggerAction) {
    var $target = this.$el.find('[data-dough-field-target="' + triggerTarget + '"]');
    $target[triggerAction === 'show' ? 'removeClass' : 'addClass']('is-hidden');

    return this;
  };

  return FieldToggleVisibility;
});
