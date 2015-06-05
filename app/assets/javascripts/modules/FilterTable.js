/**
 * # Table filter
 *
 * Requires an element to have a data-dough-component="FilterTable" attribute and an ID.
 *
 * Makes use of ListJS — see listjs.com.
 * See test fixture for sample markup - /spec/js/fixtures/FilterTable.html
 */

define(['jquery', 'DoughBaseComponent', 'List', 'ListFuzzySearch'],
       function($, DoughBaseComponent, List, ListFuzzySearch) {
  'use strict';

  var FilterTableProto,
      defaultConfig = {
        filterTargetClass: 'js-filterable',
        filterFieldClass: 'js-filter-field',
        filterListClass: 'js-filter-rows'
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
   * makeFilterTargetClasses
   *
   * Find columns with filterTargetClass and apply individual classes
   * to them, since this is what ListJS wants.
   *
   * @return {Array} array of classes used
   */
  FilterTableProto.makeFilterTargetClasses = function () {
    var filterClasses = [];

    this.$el.find('.' + this.config.filterTargetClass).each(function(_, cell) {
      var $cell = $(cell),
          filterClass = 'js-filterable-' + $cell.index();
      $cell.addClass(filterClass);
      filterClasses.push(filterClass);
    });

    return $.unique(filterClasses);
  };

  /**
   * enableFuzzySearch
   *
   * Find input field with class filterFieldClass then add fuzzy-search class to it.
   *
   */
  FilterTableProto.enableFuzzySearch = function () {
    this.$el.find('.' + this.config.filterFieldClass).each(function(_, cell) {
      $(cell).addClass('fuzzy-search');
    });
  };

  FilterTableProto.bindFilterToElements = function() {
    var firmOptions = {
      valueNames: this.makeFilterTargetClasses(),
      searchClass: this.config.filterFieldClass,
      listClass: this.config.filterListClass,
      plugins: [ListFuzzySearch()]
    };

    this.enableFuzzySearch();

    new List(this.$el.attr('id'), firmOptions);
  };

  return FilterTable;
});
