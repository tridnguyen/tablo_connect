// Karma configuration file
// See http://karma-runner.github.io/0.10/config/configuration-file.html
module.exports = function(config) {
  'use strict';

  config.set({
    basePath: '../../',

    frameworks: ['jasmine'],

    // list of files / patterns to load in the browser
    files: [
      // libraries
      'app/assets/javascripts/tablo_connect/jquery/jquery.js',
      'app/assets/javascripts/tablo_connect/angular/angular.js',
      'app/assets/javascripts/tablo_connect/angular/angular-sanitize.js',
      'app/assets/javascripts/tablo_connect/angular/angular-ui-router.js',
      'app/assets/javascripts/tablo_connect/angular/angular-mocks.js',

      // our app
      'app/assets/javascripts/tablo_connect/ng_app/app.js',
      'app/assets/javascripts/tablo_connect/ng_app/**/*.js',
      'spec/javascript/angular-environment.js',

      // tests
      'spec/javascript/unit/**/*_spec.js',

      // templates
      'app/assets/javascripts/tablo_connect/ng_app/templates/*.html',
      'app/assets/javascripts/tablo_connect/ng_app/modules/**/templates/*.html'
    ],

    // generate js files from html templates
    preprocessors: {
      'app/assets/javascripts/tablo_connect/ng_app/templates/*.html': 'ng-html2js',
      'app/assets/javascripts/tablo_connect/ng_app/modules/**/templates/*.html': 'ng-html2js'
    },
    autoWatch: true,
    browsers: ['PhantomJS'],
    ngHtml2JsPreprocessor: {
      // strip this from the file path
      stripPrefix: 'app/assets/javascripts',
      // prepend this to the file path
      prependPrefix: '/assets'
    },
    singleRun: false
  });
};
