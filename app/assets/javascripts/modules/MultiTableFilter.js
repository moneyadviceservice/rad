/**
 * # Multiple table filter
 *
 * Filters across one or more tables, and can also hide the elements associated with a table.
 *
 * Requires an element to have a data-dough-component="MultiTableFilter" attribute and an ID.
 *
 * Makes use of jquery.fastLiveFilter.
 * See test fixture for sample markup - /spec/js/fixtures/MultiTableFilter.html
 *
 * @module MultiTableFilter
 * @returns {class} MultiTableFilter
 */

define(['jquery', 'jqueryFastLiveFilter', 'DoughBaseComponent'],
       function($, jqueryFastLiveFilter, DoughBaseComponent) {
  'use strict';

  var MultiTableFilterProto,
      defaultConfig = {
        filterTargetSelector: '[data-dough-filterable]',
        filterFieldSelector:  '[data-dough-filter-input]',
        filterListSelector:   '[data-dough-filter-rows]',
        filterGroupSelector:  '[data-dough-filter-group]'
      };

  /**
   * @constructor
   * @extends {DoughBaseComponent}
   * @param {HTMLElement} $el    Element with dough-component on it
   * @param {Object}      config Hash of config options
   */
  function MultiTableFilter($el, config) {
    MultiTableFilter.baseConstructor.call(this, $el, config, defaultConfig);
  }

  /**
   * Inherit from base module, for shared methods and interface
   */
  DoughBaseComponent.extend(MultiTableFilter);
  MultiTableFilter.componentName = 'MultiTableFilter';
  MultiTableFilterProto = MultiTableFilter.prototype;

  /**
   * Init function
   *
   * Set up listeners and accept promise
   *
   * @param {Object} initialised Promise passed from eventsWithPromises (RSVP Promise).
   * @returns {MultiTableFilter}
   */
  MultiTableFilterProto.init = function(initialised) {
    this.bindFilterToElements();
    this._initialisedSuccess(initialised);
    return this;
  };

  /**
   * Show/hide filterGroups when all filterTargetSelectors are hidden
   */
  MultiTableFilterProto.toggleFilterGroups = function() {
    var self = this;

    $(self.config.filterGroupSelector).each(function(_index, filterGroup) {
      self.toggleFilterGroup(filterGroup);
    });
  };

  /**
   * Show/hide filterGroup when all filterTargetSelectors are hidden
   * @param {HTMLElement} filterGroup Element for table group wrapper
   */
  MultiTableFilterProto.toggleFilterGroup = function(filterGroup) {
    var $filterGroup = $(filterGroup),
        $list = $filterGroup.find(this.config.filterListSelector),
        $rows = $list.first().find('tr'),
        hiddenRows;

    // We might use jQuery `:hidden` here — but we can't, because
    // if we've hidden our filterGroup, then `:hidden` will be true
    // for all our rows.
    // But when fastLiveFilter unhides a row indivudally, we need to know
    // so that we can unhide the group. So we test on individual elements.
    hiddenRows = $rows.filter(function() {
      return $(this).css('display') == 'none';
    });

    if(hiddenRows.length == $rows.length) {
      $filterGroup.hide();
    } else {
      $filterGroup.show();
    }
  };

  /**
   * Binds filter library to text field and table groups
   */
  MultiTableFilterProto.bindFilterToElements = function() {
    var self = this;

    $(self.config.filterFieldSelector).fastLiveFilter(self.config.filterListSelector, {
      selector: self.config.filterTargetSelector,
      callback: function(total) {
        self.toggleFilterGroups();
      }
    });
  };

  return MultiTableFilter;
});
