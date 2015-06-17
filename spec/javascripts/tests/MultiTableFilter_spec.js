describe('filter table based on text field criteria', function () {
  'use strict';

  function visibleRows() {
    return $('[data-dough-filter-rows]').find('tr:visible');
  }

  function setFilterText(text) {
    $('[data-dough-filter-input]').val(text);
    $('[data-dough-filter-input]').change();
  }

  describe('on a table', function() {
    beforeEach(function (done) {
      var self = this;

      requirejs(['jquery', 'MultiTableFilter'], function ($, MultiTableFilter) {
        self.$html = $(window.__html__['spec/javascripts/fixtures/MultiTableFilter.html']).appendTo('body');
        self.component = self.$html.find('[data-dough-component="MultiTableFilter"]');
        self.MultiTableFilter = new MultiTableFilter(self.component).init();

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
        setFilterText('');
      });

      it('shows all rows', function () {
        expect(visibleRows().length).to.eq(3);
      });
    });

    describe('when text matching a single row is entered into the field', function () {
      beforeEach(function() {
        setFilterText('lex');
      });

      it('shows only that row', function () {
        expect(visibleRows().length).to.eq(1);
        expect(visibleRows().eq(0).text()).to.include('Alex');
      });
    });

    describe('when text matching multiple rows is entered into the field', function () {
      beforeEach(function() {
        setFilterText('a');
      });

      it('shows only those rows', function () {
        expect(visibleRows().length).to.eq(2);
        expect(visibleRows().eq(0).text()).to.include('Alex');
        expect(visibleRows().eq(1).text()).to.include('Cameron');
      });
    });

    describe('when text matching no rows is entered into the field', function () {
      beforeEach(function() {
        setFilterText('orange');
      });

      it('shows no rows', function () {
        expect(visibleRows().length).to.eq(0);
      });

      describe('when the text is cleared', function() {
        beforeEach(function() {
          setFilterText('');
        });

        it('shows all rows again', function () {
          expect(visibleRows().length).to.eq(3);
        });
      });
    });

    describe('when text matching the second column of one row is entered into the field', function () {
      beforeEach(function() {
        setFilterText('Bristol');
      });

      it('shows only that row', function () {
        expect(visibleRows().length).to.eq(1);
        expect(visibleRows().eq(0).text()).to.include('Alex');
      });
    });
  });
});
