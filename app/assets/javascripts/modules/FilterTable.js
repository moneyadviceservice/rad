/**
 * # Table filter
 *
 * Requires an element to have a data-dough-component="FilterTable" attribute and an ID.
 *
 * Makes use of ListJS — see listjs.com.
 * See test fixture for sample markup - /spec/js/fixtures/FilterTable.html
 */

define(['jquery', 'jqueryFastLiveFilter', 'DoughBaseComponent', 'List'],
       function($, jqueryFastLiveFilter, DoughBaseComponent, List) {
  'use strict';

  var FilterTableProto,
      defaultConfig = {
        filterTargetClass: '.js-filterable',
        filterFieldClass: '.js-filter-field',
        filterListClass: '.js-filter-rows',
        filterWrapperClass: '.js-filter-wrapper',
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
   * toggleFilterWrappers function
   *
   * show/hide fitlerWrappers when all filterTargetClasses are hidden
   *
   */
  FilterTableProto.toggleFilterWrappers = function() {
  	var self = this;

		$(self.config.filterWrapperClass).each( function(index, element ) {
			self.toggleFilterWrapper( $(element) )
		});
	}

  /**
   * toggleFilterWrapper function
   *
   * show/hide fitlerWrapper when all filterTargetClasses are hidden
   *
   */

  FilterTableProto.toggleFilterWrapper = function(element) {
		var list = element.find(this.config.filterListClass)
		var rows = $(list[0]).find('tr')
		var hidden_rows = $(rows).filter(function() {
		  return $(this).css('display') == 'none';
		});

		if(hidden_rows.length == rows.length) {
			element.hide();
		} else {
			element.show();
		}
  };

  FilterTableProto.bindFilterToElements = function() {
  	var self = this

		$(this.config.filterFieldClass).fastLiveFilter(this.config.filterListClass, {
			selector: self.config.filterTargetClass,
			callback: function(total) {
				self.toggleFilterWrappers();
			}
		});
  };

  return FilterTable;
});
