describe('filters', function () {
  'use strict';

  beforeEach(module('ac.url'));

  describe('urlencode', function () {
    describe('when the value is undefined', function () {
      it('returns undefined', inject(function (urlencodeFilter) {
        expect(urlencodeFilter(undefined)).toBe(undefined);
      }));
    });

    describe('when the value is defined', function () {
      it('returns the string url encoded', inject(function (urlencodeFilter) {
        expect(urlencodeFilter('20/20')).toBe('20%2F20');
      }));
    });
  });

  describe('urldecode', function () {
    describe('when the value is undefined', function () {
      it('returns undefined', inject(function (urldecodeFilter) {
        expect(urldecodeFilter(undefined)).toBe(undefined);
      }));
    });

    describe('when the value is defined', function () {
      it('returns the string url decoded', inject(function (urldecodeFilter) {
        expect(urldecodeFilter('20%2F20')).toBe('20/20');
      }));
    });
  });

  describe('tabloBaseUrl', function () {
    describe('when the value is undefined', function () {
      it('returns undefined', inject(function (tabloBaseUrlFilter) {
        expect(tabloBaseUrlFilter(undefined)).toBe(undefined);
      }));
    });

    describe('when the value is defined', function () {
      it('returns the fully qualified domain with port', inject(function (tabloBaseUrlFilter) {
        expect(tabloBaseUrlFilter('127.0.0.1')).toBe('http://127.0.0.1:18080');
      }));
    });
  });
});