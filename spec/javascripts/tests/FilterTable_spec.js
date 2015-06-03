describe('filter table based on text field criteria', function () {
  'use strict';

  function fireKeyup(el) {
    el = el[0] || el; // Unwrap JQuery objects
    var evObj = document.createEvent('UIEvents');
    evObj.initUIEvent('keyup', true, true, window, 1);
    el.dispatchEvent(evObj);
  }

  describe('on a table', function() {
    beforeEach(function (done) {
      var self = this;

      requirejs(['jquery', 'FilterTable'], function ($, FilterTable) {
        self.$html = $(window.__html__['spec/javascripts/fixtures/FilterTable.html']).appendTo('body');
        self.component = self.$html.find('[data-dough-component="FilterTable"]');
        self.FilterTable = FilterTable;

        self.filterTable = new self.FilterTable(self.component).init();
        self.$field = self.component.find('.js-filter-field');
        self.$rows = self.component.find('.js-filter-rows');
        self.getRows = $.proxy(self.$rows.children, self.$rows);

        done();
      }, done);
    });

    afterEach(function() {
      this.$html.remove();
    });

    it('exists', function() {
      expect(this.component).to.exist;
    });

    describe('when no text is entered into the field', function () {
      beforeEach(function() {
        this.$field.val('');
        fireKeyup(this.$field);
      });

      it('shows all rows', function () {
        expect(this.getRows().length).to.eq(3);
      });
    });

    describe('when text matching a single row is entered into the field', function () {
      beforeEach(function() {
        this.$field.val('lex');
        fireKeyup(this.$field);
      });

      it('shows only that row', function () {
        expect(this.getRows().length).to.eq(1);
        expect(this.getRows().eq(0).text()).to.include('Alex');
      });
    });

    describe('when text matching multiple rows is entered into the field', function () {
      beforeEach(function() {
        this.$field.val('a');
        fireKeyup(this.$field);
      });

      it('shows only those rows', function () {
        expect(this.getRows().length).to.eq(2);
        expect(this.getRows().eq(0).text()).to.include('Alex');
        expect(this.getRows().eq(1).text()).to.include('Cameron');
      });
    });

    describe('when text matching no rows is entered into the field', function () {
      beforeEach(function() {
        this.$field.val('orange');
        fireKeyup(this.$field);
      });

      it('shows no rows', function () {
        expect(this.getRows().length).to.eq(0);
      });
    });
  });
});
