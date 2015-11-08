'use strict';

/* jasmine specs for filters go here */

describe('filters', function () {
  beforeEach(module('ac.titleize'));

  describe('titleize', function () {
    it('returns a formatted string with spaces as a title', inject(function (titleizeFilter) {
      expect(titleizeFilter('the quick red fox')).toBe('The Quick Red Fox');
    }));

    it('returns a formatted string with underscores as a title', inject(function (titleizeFilter) {
      expect(titleizeFilter('jumped_over_the_lazy_brown_dog')).toBe('Jumped Over The Lazy Brown Dog');
    }));

    it('returns a formatted string with underscores and spaces as a title', inject(function (titleizeFilter) {
      expect(titleizeFilter('lorem_ipsum dolor sit_amEt, conSectetur adipisicing elit')).toBe('Lorem Ipsum Dolor Sit Amet, Consectetur Adipisicing Elit');
    }));

    it('returns the value if it is not truthy', inject(function (titleizeFilter) {
      expect(titleizeFilter(undefined)).toBe(undefined);
    }));
  });
});