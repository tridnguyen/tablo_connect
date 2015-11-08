describe('tabloService', function () {
  'use strict';

  var $httpBackend,
      tabloService;

  beforeEach(module('ac.tabloConnectApp', 'ac.tabloService'));

  beforeEach(inject(function (_$httpBackend_, _tabloService_) {
    $httpBackend = _$httpBackend_;
    tabloService = _tabloService_;
  }));

  afterEach(function () {
    $httpBackend.verifyNoOutstandingExpectation();
    $httpBackend.verifyNoOutstandingRequest();
  });

  describe('initCopy', function () {
    it('sets the recording.copy_status to in_progress', function () {
      $httpBackend.expectGET('/tablo/copy/1234/movie').respond({copy_status: 'in_progress'});
      var recording = {tablo_id: 1234};
      tabloService.initCopy(recording, 'movie');
      $httpBackend.flush();
      expect(recording.copy_status).toEqual('in_progress');
    });
  });
});