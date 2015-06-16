/**
 * # Multiple table filter
 *
 * Filters across one or more tables, and can also hide the elements associated with a table.
 *
 * Requires an element to have a data-dough-component="MultiTableFilter" attribute and an ID.
 *
 * Makes use of jquery.fastLiveFilter.
 * See test fixture for sample markup - /spec/js/fixtures/MultiTableFilter.html
 */

define(['jquery', 'jqueryFastLiveFilter', 'DoughBaseComponent'],
       function($, jqueryFastLiveFilter, DoughBaseComponent) {
  'use strict';

  var MultiTableFilterProto,
      defaultConfig = {
        filterTargetSelector: '.js-filterable',
        filterFieldSelector: '.js-filter-input',
        filterListSelector: '.js-filter-rows',
        filterGroupSelector: '.js-filter-group'
      };

  function MultiTableFilter($el, config) {
    MultiTableFilter.baseConstructor.call(this, $el, config, defaultConfig);
  }

  /**
   * Inherit from base module, for shared methods and interface
   * @type {[type]}
   * @private
   */
  DoughBaseComponent.extend(MultiTableFilter);
  MultiTableFilter.componentName = 'MultiTableFilter';
  MultiTableFilterProto = MultiTableFilter.prototype;

  /**
   * Init function
   *
   * Set up listeners and accept promise
   *
   * @param  {[type]} initialised [description]
   * @return {[type]}             [description]
   */
  MultiTableFilterProto.init = function(initialised) {
    this.bindFilterToElements();
    this._initialisedSuccess(initialised);
    return this;
  };

  /**
   * show/hide filterGroups when all filterTargetSelectores are hidden
   */
  MultiTableFilterProto.toggleFilterGroups = function() {
    var self = this;

    $(self.config.filterGroupSelector).each(function(_index, filterGroup) {
      self.toggleFilterGroup(filterGroup);
    });
  };

  /**
   * show/hide filterGroup when all filterTargetSelectores are hidden
   */

  MultiTableFilterProto.toggleFilterGroup = function(filterGroup) {
    var $filterGroup = $(filterGroup),
        $list = $filterGroup.find(this.config.filterListSelector),
        $rows = $list.first().find('tr'),
        hiddenRows;

    hiddenRows = $rows.filter(function() {
      return $(this).css('display') == 'none';
    });

    if(hiddenRows.length == $rows.length) {
      $filterGroup.hide();
    } else {
      $filterGroup.show();
    }
  };

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
