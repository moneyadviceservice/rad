describe('show content block on click of radio button', function () {

  'use strict';

  describe('on a simple form with hidden by default', function() {
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

    it('exists', function() {
      var fieldToggleVisibility = new this.FieldToggleVisibility(this.component).init();
      expect(this.component).to.exist;
    });

    it('adds is-hidden class to target elements if applicable', function() {
      var fieldToggleVisibility = new this.FieldToggleVisibility(this.component).init(),
          $triggers = fieldToggleVisibility.$el.find('[data-dough-field-target]');

      expect($triggers).to.have.class('is-hidden');
    });

    it('shows the target element when radio button is checked', function () {
      var fieldToggleVisibility = new this.FieldToggleVisibility(this.component).init(),
          $showTrigger = fieldToggleVisibility.$triggers.filter('[data-dough-field-trigger-type="show"]'),
          triggerTarget = $showTrigger.attr('data-dough-field-trigger'),
          $target = fieldToggleVisibility.$el.find('[data-dough-field-target="' + triggerTarget + '"]');

      $showTrigger.trigger('click');
      expect($showTrigger).to.be.checked;
      expect($target).to.not.have.class('is-hidden');
    });

    it('hides the target element when radio button is checked', function () {
      var fieldToggleVisibility = new this.FieldToggleVisibility(this.component).init(),
          $hideTrigger = fieldToggleVisibility.$triggers.filter('[data-dough-field-trigger-type="hide"]'),
          triggerTarget = $hideTrigger.attr('data-dough-field-trigger'),
          $target = fieldToggleVisibility.$el.find('[data-dough-field-target="' + triggerTarget + '"]');

      $hideTrigger.trigger('click');
      expect($hideTrigger).to.be.checked;
      expect($target).to.have.class('is-hidden');
    });
  });



  describe('on a form with multiple targets', function() {
    beforeEach(function (done) {
      var self = this;

      requirejs(['jquery', 'FieldToggleVisibility'], function ($, FieldToggleVisibility) {

        self.$html = $(window.__html__['spec/javascripts/fixtures/FieldToggleVisibilityMultiple.html']).appendTo('body');
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

    it('shows the correct target', function() {
      var fieldToggleVisibility = new this.FieldToggleVisibility(this.component).init(),
          $showTrigger1 = fieldToggleVisibility.$triggers.filter('[data-dough-field-trigger-type="show"]').filter('[data-dough-field-trigger="1"]'),
          $showTrigger2 = fieldToggleVisibility.$triggers.filter('[data-dough-field-trigger-type="show"]').filter('[data-dough-field-trigger="2"]'),
          $target1 = fieldToggleVisibility.$el.find('[data-dough-field-target="1"]'),
          $target2 = fieldToggleVisibility.$el.find('[data-dough-field-target="2"]');

      $showTrigger2.trigger('click');
      expect($showTrigger2).to.be.checked;
      expect($target1).to.have.class('is-hidden');
      expect($target2).to.not.have.class('is-hidden');
    });

    it('hides the correct target', function() {
      var fieldToggleVisibility = new this.FieldToggleVisibility(this.component).init(),
          $hideTrigger1 = fieldToggleVisibility.$triggers.filter('[data-dough-field-trigger-type="hide"]').filter('[data-dough-field-trigger="1"]'),
          $hideTrigger2 = fieldToggleVisibility.$triggers.filter('[data-dough-field-trigger-type="hide"]').filter('[data-dough-field-trigger="2"]'),
          $target1 = fieldToggleVisibility.$el.find('[data-dough-field-target="1"]'),
          $target2 = fieldToggleVisibility.$el.find('[data-dough-field-target="2"]');

      $hideTrigger2.trigger('click');
      expect($hideTrigger2).to.be.checked;
      expect($target1).to.have.class('is-hidden');
      expect($target2).to.have.class('is-hidden');
    });
  });

  describe('on a simple form with hidden by default', function() {
    beforeEach(function (done) {
      var self = this;

      requirejs(['jquery', 'FieldToggleVisibility'], function ($, FieldToggleVisibility) {

        self.$html = $(window.__html__['spec/javascripts/fixtures/FieldToggleVisibilityShown.html']).appendTo('body');
        self.component = self.$html.find('[data-dough-component="FieldToggleVisibility"]');
        self.FieldToggleVisibility = FieldToggleVisibility;

        done();
      }, done);
    });

    afterEach(function() {
      this.$html.remove();
    });

    it('does not add is-hidden if "show" option is pre-checked', function() {
      var fieldToggleVisibility = new this.FieldToggleVisibility(this.component).init(),
          $triggers = fieldToggleVisibility.$el.find('[data-dough-field-target]');

      expect($triggers).to.not.have.class('is-hidden');
    });
  });
});
