/**
 * # Language selector
 *
 * A set of select boxes that let the user select multiple languages.
 *
 * See test fixture (/spec/javascripts/fixtures/LanguageSelector.html)
 * for example markup.
 *
 * @module LanguageSelector
 * @returns {class} LanguageSelector
 */

define(['jquery', 'DoughBaseComponent'],
       function($, DoughBaseComponent) {
  'use strict';

  var LanguageSelectorProto,
      defaultConfig = {
        messageAttribute: 'data-dough-confirmation-message',
        selectorPrefix: 'data-dough-language-selector'
      };

  /**
   * @constructor
   * @extends {DoughBaseComponent}
   * @param {HTMLElement} $el    Element with dough-component on it
   * @param {Object}      config Hash of config options
   */
  function LanguageSelector($el, config) {
    LanguageSelector.baseConstructor.call(this, $el, config, defaultConfig);
  }

  /**
   * Inherit from base module, for shared methods and interface
   */
  DoughBaseComponent.extend(LanguageSelector);
  LanguageSelector.componentName = 'LanguageSelector';
  LanguageSelectorProto = LanguageSelector.prototype;

  /**
   * Init function
   *
   * Set up listeners and accept promise
   *
   * @param {Object} initialised Promise passed from eventsWithPromises (RSVP Promise).
   * @returns {LanguageSelector}
   */
  LanguageSelectorProto.init = function(initialised) {
    this.bindToElements();
    this._initialisedSuccess(initialised);
    return this;
  };

  /**
   * Bind to events on elements
   *
   * Just the add and delete language links.
   */
  LanguageSelectorProto.bindToElements = function() {
    this.$find('add-language').on('click', $.proxy(this.addLanguage, this));
    this.$el.on('click', this._buildSelectorQuery('delete-language'), $.proxy(this.deleteLanguage, this));
  };

  /**
   * Add a new language selector to the list of selectors
   *
   * Employs a template and clears all relevant attributes from it
   * before cloning and inserting.
   */
  LanguageSelectorProto.addLanguage = function() {
    var $container = this.$find('selectors').first(),
        $template = this.$find('template').clone();
    $template.find('select')
      .attr('id', '');
    $template
      .removeClass('language-selector__template')
      .removeAttr(this.config.selectorPrefix + '-template')
      .attr(this.config.selectorPrefix + '-selector', true)
      .appendTo($container);
  };

  /**
   * Delete a selector
   *
   * Uses the event target to work out which one to delete.
   *
   * @param {Event} Click event on a delete link
   */
  LanguageSelectorProto.deleteLanguage = function(e) {
    var $selector = $(e.target).parents(this._buildSelectorQuery('selector'));
    $selector.remove();
  };

  LanguageSelectorProto.$find = function(selector) {
    return this.$el.find(this._buildSelectorQuery(selector));
  };

  LanguageSelectorProto._buildSelectorQuery = function(selector) {
    return '[' + this.config.selectorPrefix + '-' + selector + ']';
  };

  return LanguageSelector;
});
