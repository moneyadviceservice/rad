describe('show content block on click of radio button', function () {

  'use strict';

  beforeEach(function (done) {
    var self = this;

    requirejs(['jquery', 'FieldToggleVisibility'], function ($, FieldToggleVisibility) {

      self.$html = $(window.__html__['spec/javascripts/fixtures/FieldToggleVisibility.html']).appendTo('body');
      self.component = self.$html.find('[data-dough-component="FieldToggleVisibility"]');
      self.FieldToggleVisibility = FieldToggleVisibility;

      done();
    }, done);
  });

  afterEach(function() {
    this.$html.remove();
  });

  it('exists', function () {
    var fieldToggleVisibility = new this.FieldToggleVisibility(this.component).init();
    expect(this.component).to.exist;
  });

  it('shows the target element when radio button is checked', function () {
    var fieldToggleVisibility = new this.FieldToggleVisibility(this.component).init(),
        $showTrigger = fieldToggleVisibility.triggers.filter('[data-dough-field-trigger="show"]');

    $showTrigger.trigger('click');
    expect($showTrigger).to.be.checked;
    expect(fieldToggleVisibility.target).to.not.have.class('is-hidden');
  });

  it('hide the target element when radio button is unchecked', function () {
    var fieldToggleVisibility = new this.FieldToggleVisibility(this.component).init(),
      $hideTrigger = fieldToggleVisibility.triggers.filter('[data-dough-field-trigger="hide"]'),
      $showTrigger = fieldToggleVisibility.triggers.filter('[data-dough-field-trigger="show"]');;

    $hideTrigger.trigger('click');
    expect($showTrigger).to.not.be.checked;
    expect(fieldToggleVisibility.target).to.have.class('is-hidden');
  });
});