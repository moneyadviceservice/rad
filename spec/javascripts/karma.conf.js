module.exports = function(config) {
  config.set({
    basePath: '../../',
    frameworks: ['requirejs', 'mocha', 'chai-jquery', 'chai', 'jquery-1.11.0'],

    files: [
      'spec/javascripts/test-main.js',
      'spec/javascripts/fixtures/*.html',
      {pattern: 'app/assets/javascripts/**/*.js', included: false},
      {pattern: 'vendor/assets/bower_components/**/*.js', included: false},
      {pattern: 'vendor/assets/javascripts/**/*.js', included: false},
      {pattern: 'spec/javascripts/tests/*_spec.js', included: false}
    ],

    exclude: [
      'vendor/assets/bower_components/**/test/**/*.js',
      'vendor/assets/bower_components/**/spec/**/*.js'
    ],

    // preprocess matching files before serving them to the browser
    // available preprocessors: https://npmjs.org/browse/keyword/karma-preprocessor
    preprocessors: {
      '**/*.html': ['html2js']
    },

    reporters: ['progress'],
    port: 9876,
    colors: true,
    logLevel: config.LOG_INFO,

    // enable / disable watching file and executing tests whenever any file changes
    autoWatch: true,
    browsers: ['PhantomJS'],
    captureTimeout: 60000,

    // Continuous Integration mode
    // if true, it capture browsers, run tests and exit
    singleRun: false
  });
};
