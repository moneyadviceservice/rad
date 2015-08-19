describe('language selector', function () {
  'use strict';
  var sandbox;

  beforeEach(function (done) {
    var self = this;

    requirejs(['jquery', 'LanguageSelector'], function ($, LanguageSelector) {
      self.$html = $(window.__html__['spec/javascripts/fixtures/LanguageSelector.html']).appendTo('body');
      self.LanguageSelector = new LanguageSelector(self.$html).init();
      self.$selectorsContainer = self.$html.find('[data-dough-language-selector-selectors]');
      self.$template = self.$html.find('[data-dough-language-selector-template]');
      self.$addLanguage = self.$html.find('[data-dough-language-selector-add-language]');
      self.$selectors = function() { return self.$html.find('[data-dough-language-selector-selector]'); };
      done();
    }, done);
  });

  afterEach(function() {
    this.$html.remove();
  });

  context('when "add language" is clicked', function() {
    beforeEach(function() { this.$addLanguage.trigger('click'); });

    it('adds a new select box', function() {
      expect(this.$selectors().length).to.eq(2);
    });

    it('clears attributes from select element', function() {
      expect(this.$selectorsContainer.find('select').last().attr('id')).to.eq('');
    });

    it('does not duplicate template', function() {
      expect(this.$html.find('[data-dough-language-selector-template]').length).to.eq(1);
    });

    context('when "remove language" is clicked', function() {
      beforeEach(function() {
        this.$selectors().last().find('[data-dough-language-selector-delete-language]').trigger('click');
      });

      it('removes the language', function() {
        expect(this.$selectors().length).to.eq(1);
      });
    });
  });
});
