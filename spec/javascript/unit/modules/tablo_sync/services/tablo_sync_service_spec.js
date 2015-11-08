describe('tabloSyncService', function () {
  'use strict';

  var $httpBackend,
      tabloSyncService;

  beforeEach(module('ngSanitize',
      'ac.tabloSyncService'
  ));

  beforeEach(inject(function (_$httpBackend_, _tabloSyncService_) {
    $httpBackend = _$httpBackend_;
    tabloSyncService = _tabloSyncService_;
  }));

  afterEach(function () {
    $httpBackend.verifyNoOutstandingExpectation();
    $httpBackend.verifyNoOutstandingRequest();
  });

  describe('syncData()', function () {
    it('returns the syncData', function () {
      expect(tabloSyncService.syncData()).toEqual({});
    });
  });
});