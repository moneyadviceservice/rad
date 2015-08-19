var allTestFiles = [];
var TEST_REGEXP = /(spec|test)\.js$/i;

var pathToModule = function (path) {
  return path.replace(/^\/base\//, '').replace(/\.js$/, '');
};

Object.keys(window.__karma__.files).forEach(function (file) {
  if (TEST_REGEXP.test(file)) {
    // Normalize paths to RequireJS module names.
    allTestFiles.push(pathToModule(file));
  }
});

require.config({
  // Karma serves files under /base, which is the basePath from your config file
  baseUrl: '/base',

  // dynamically load all test files
  deps: allTestFiles,

  // we have to kickoff jasmine, as it is asynchronous
  callback: window.__karma__.start,
  paths: {
    componentLoader: 'vendor/assets/bower_components/dough/assets/js/lib/componentLoader',
    DoughBaseComponent: 'vendor/assets/bower_components/dough/assets/js/components/DoughBaseComponent',
    jquery: 'vendor/assets/bower_components/jquery/dist/jquery',
    jqueryFastLiveFilter: 'vendor/assets/bower_components/jquery-fastlivefilter/jquery.fastLiveFilter',
    FieldToggleVisibility: 'app/assets/javascripts/modules/FieldToggleVisibility',
    MultiTableFilter: 'app/assets/javascripts/modules/MultiTableFilter',
    ConfirmableForm: 'app/assets/javascripts/modules/ConfirmableForm',
    LanguageSelector: 'app/assets/javascripts/modules/LanguageSelector',
    utilities: 'vendor/assets/bower_components/dough/assets/js/lib/utilities',
    List: 'vendor/assets/bower_components/list.js/dist/list'
  },

  shim: {
    modernizr: {
      exports: 'Modernizr'
    }
  }
});
