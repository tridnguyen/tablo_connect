describe('MoviesCtrl', function () {
  'use strict';

  var $httpBackend,
      scope,
      ctrl,
      alertsService,
      tabloService,
      tabloBaseUrl;

  beforeEach(module('ac.tabloConnectApp'));

  beforeEach(inject(function ($rootScope, $controller, _$httpBackend_, _alertsService_, _tabloService_, _tabloBaseUrl_) {
    $httpBackend = _$httpBackend_;
    scope = $rootScope.$new();
    alertsService = _alertsService_;
    tabloService = _tabloService_;
    tabloBaseUrl = _tabloBaseUrl_;
    spyOn(alertsService, 'getAlerts').and.callThrough();
    spyOn(tabloService, 'movieData').and.callThrough();
    spyOn(tabloService, 'initPollStatus').and.callThrough();
    ctrl = $controller('MoviesCtrl', {$scope: scope, $element: scope.$element, tabloBaseUrl: tabloBaseUrl});
  }));

  afterEach(function () {
    $httpBackend.verifyNoOutstandingExpectation();
    $httpBackend.verifyNoOutstandingRequest();
  });

  it("calls alertsService.getAlerts()", function () {
    expect(alertsService.getAlerts).toHaveBeenCalled();
  });

  it("calls tabloService.movieData", function () {
    expect(tabloService.movieData).toHaveBeenCalled();
  });

  it('sets the tabloBaseUrl', function () {
    expect(scope.tabloBaseUrl).toEqual(tabloBaseUrl);
  });

  describe('$scope.copyRecording', function () {
    it('calls tabloService.initCopy', function () {
      spyOn(tabloService, 'initCopy');
      spyOn(alertsService, 'clearAlerts');
      scope.copyRecording({tablo_id: 1234});
      expect(tabloService.initCopy).toHaveBeenCalledWith({tablo_id: 1234}, 'movie');
      expect(alertsService.clearAlerts).toHaveBeenCalled();
    });
  });

  it("calls tabloService.initPollStatus", function () {
    expect(tabloService.initPollStatus).toHaveBeenCalledWith([], 'movie');
  });
});