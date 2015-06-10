/**
 * # Table filter
 *
 * Requires an element to have a data-dough-component="FilterTable" attribute and an ID.
 *
 * Makes use of jquery.fastLiveFilter.
 * See test fixture for sample markup - /spec/js/fixtures/FilterTable.html
 */

define(['jquery', 'jqueryFastLiveFilter', 'DoughBaseComponent'],
       function($, jqueryFastLiveFilter, DoughBaseComponent) {
  'use strict';

  var FilterTableProto,
      defaultConfig = {
        filterTargetSelector: '.js-filterable',
        filterFieldSelector: '.js-filter-field',
        filterListSelector: '.js-filter-rows',
        filterWrapperSelector: '.js-filter-wrapper'
      };

  function FilterTable($el, config) {
    FilterTable.baseConstructor.call(this, $el, config, defaultConfig);
  }

  /**
   * Inherit from base module, for shared methods and interface
   * @type {[type]}
   * @private
   */
  DoughBaseComponent.extend(FilterTable);
  FilterTable.componentName = 'FilterTable';
  FilterTableProto = FilterTable.prototype;

  /**
   * Init function
   *
   * Set up listeners and accept promise
   *
   * @param  {[type]} initialised [description]
   * @return {[type]}             [description]
   */
  FilterTableProto.init = function(initialised) {
    this.bindFilterToElements();
    this._initialisedSuccess(initialised);
    return this;
  };

  /**
   * show/hide filterWrappers when all filterTargetSelectores are hidden
   */
  FilterTableProto.toggleFilterWrappers = function() {
    var self = this;

    $(self.config.filterWrapperSelector).each(function(_index, filterWrapper) {
      self.toggleFilterWrapper(filterWrapper);
    });
  };

  /**
   * show/hide filterWrapper when all filterTargetSelectores are hidden
   */

  FilterTableProto.toggleFilterWrapper = function(filterWrapper) {
    var $filterWrapper = $(filterWrapper),
        $list = $filterWrapper.find(this.config.filterListSelector),
        $rows = $list.first().find('tr'),
        hiddenRows;

    hiddenRows = $rows.filter(function() {
      return $(this).css('display') == 'none';
    });

    if(hiddenRows.length == $rows.length) {
      $filterWrapper.hide();
    } else {
      $filterWrapper.show();
    }
  };

  FilterTableProto.bindFilterToElements = function() {
    var self = this;

    $(self.config.filterFieldSelector).fastLiveFilter(self.config.filterListSelector, {
      selector: self.config.filterTargetSelector,
      callback: function(total) {
        self.toggleFilterWrappers();
      }
    });
  };

  return FilterTable;
});
