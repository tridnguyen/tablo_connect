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
      var recording = {tablo_ip: '127.0.0.1', tablo_id: 1234};
      $httpBackend.expectGET('/tablo/copy/1234/movie?tablo_ip=127.0.0.1').respond({copy_status: 'in_progress'});
      tabloService.initCopy(recording, 'movie');
      $httpBackend.flush();
      expect(recording.copy_status).toEqual('in_progress');
    });
  });
});