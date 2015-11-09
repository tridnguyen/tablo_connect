describe('EpisodesCtrl', function () {
  'use strict';

  var $httpBackend,
      scope,
      ctrl,
      alertsService,
      tabloService;

  beforeEach(module('ac.tabloConnectApp'));

  beforeEach(inject(function ($rootScope, $controller, _$httpBackend_, _alertsService_, _tabloService_) {
    $httpBackend = _$httpBackend_;
    scope = $rootScope.$new();
    alertsService = _alertsService_;
    tabloService = _tabloService_;
    spyOn(alertsService, 'getAlerts').and.callThrough();
    spyOn(tabloService, 'episodeData').and.callThrough();
    spyOn(tabloService, 'initPollStatus').and.callThrough();
    ctrl = $controller('EpisodesCtrl', {$scope: scope, $element: scope.$element});
  }));

  afterEach(function () {
    $httpBackend.verifyNoOutstandingExpectation();
    $httpBackend.verifyNoOutstandingRequest();
  });

  it ("calls alertsService.getAlerts()", function(){
    expect(alertsService.getAlerts).toHaveBeenCalled();
  });

  it ("calls tabloService.episodeData", function(){
    expect(tabloService.episodeData).toHaveBeenCalled();
  });

  describe('$scope.copyRecording', function () {
    it('calls tabloService.initCopy', function () {
      spyOn(tabloService, 'initCopy');
      spyOn(alertsService, 'clearAlerts');
      scope.copyRecording({tablo_id: 1234});
      expect(tabloService.initCopy).toHaveBeenCalledWith({tablo_id: 1234}, 'show');
      expect(alertsService.clearAlerts).toHaveBeenCalled();
    });
  });

  it ("calls tabloService.initPollStatus", function(){
    expect(tabloService.initPollStatus).toHaveBeenCalledWith([], 'show');
  });
});