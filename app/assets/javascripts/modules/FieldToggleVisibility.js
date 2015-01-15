/**
 * # Element visibility toggler.
 *
 * Requires an element to have a data-dough-component="FieldToggleVisibility" attribute. The application
 * file will spawn an instance of this class for each element it finds on the page.
 *
 * Events used: toggler:toggled(element, isShown) [Event for when the toggler is doing its work]
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
    this.triggers = this.$el.find('[data-dough-field-trigger]');
    this.target = this.$el.find('[data-dough-field-target]');
  }

  /**
   * Inherit from base module, for shared methods and interface
   * @type {[type]}
   * @private
   */

  DoughBaseComponent.extend(FieldToggleVisibility);
  FieldToggleVisibilityProto = FieldToggleVisibility.prototype;

  FieldToggleVisibilityProto.init = function(initialised) {
    var self = this;

    this.triggers.on('change', function() {
      var thisTrigger = $(this),
          triggerType = thisTrigger.attr('data-dough-field-trigger'); // will be show or hide

      if (triggerType == 'show') {
        self.target.removeClass('is-hidden');
      } else {
        self.target.addClass('is-hidden');
      }
    });
    this._initialisedSuccess(initialised);

    return this;
  }

  return FieldToggleVisibility;
});