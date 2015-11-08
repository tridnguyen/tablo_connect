describe('HomeCtrl', function () {
  'use strict';

  var $httpBackend,
      scope,
      ctrl,
      alertsService,
      tabloSyncService;

  beforeEach(module('ac.tabloConnectApp'));

  beforeEach(inject(function ($rootScope, $controller, _$httpBackend_, _alertsService_, _tabloSyncService_) {
    $httpBackend = _$httpBackend_;
    scope = $rootScope.$new();
    alertsService = _alertsService_;
    tabloSyncService = _tabloSyncService_;
    spyOn(alertsService, 'getAlerts').and.callThrough();
    spyOn(tabloSyncService, 'syncData').and.callThrough();
    ctrl = $controller('HomeCtrl', {$scope: scope, $element: scope.$element});
  }));

  afterEach(function () {
    $httpBackend.verifyNoOutstandingExpectation();
    $httpBackend.verifyNoOutstandingRequest();
  });

  it ("calls alertsService.getAlerts()", function(){
    expect(alertsService.getAlerts).toHaveBeenCalled();
  });

  it ("calls tabloSyncService.syncData", function(){
    expect(tabloSyncService.syncData).toHaveBeenCalled();
  });
});