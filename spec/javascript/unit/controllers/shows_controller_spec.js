describe('ShowsCtrl', function () {
  'use strict';

  var $httpBackend,
      scope,
      ctrl,
      tabloService;

  beforeEach(module('ac.tabloConnectApp'));

  beforeEach(inject(function ($rootScope, $controller, _$httpBackend_, _tabloService_) {
    $httpBackend = _$httpBackend_;
    scope = $rootScope.$new();
    tabloService = _tabloService_;
    spyOn(tabloService, 'showData').and.callThrough();
    ctrl = $controller('ShowsCtrl', {$scope: scope, $element: scope.$element});
  }));

  afterEach(function () {
    $httpBackend.verifyNoOutstandingExpectation();
    $httpBackend.verifyNoOutstandingRequest();
  });

  it ("calls tabloService.showData", function(){
    expect(tabloService.showData).toHaveBeenCalled();
  });
});