describe('ShowsCtrl', function () {
  'use strict';

  var $httpBackend,
      scope,
      ctrl,
      tabloService,
      tabloBaseUrl;

  beforeEach(module('ac.tabloConnectApp'));

  beforeEach(inject(function ($rootScope, $controller, _$httpBackend_, _tabloService_, _tabloBaseUrl_) {
    $httpBackend = _$httpBackend_;
    scope = $rootScope.$new();
    tabloService = _tabloService_;
    tabloBaseUrl = _tabloBaseUrl_;
    spyOn(tabloService, 'showData').and.callThrough();
    ctrl = $controller('ShowsCtrl', {$scope: scope, $element: scope.$element, tabloBaseUrl: tabloBaseUrl});
  }));

  afterEach(function () {
    $httpBackend.verifyNoOutstandingExpectation();
    $httpBackend.verifyNoOutstandingRequest();
  });

  it ("calls tabloService.showData", function(){
    expect(tabloService.showData).toHaveBeenCalled();
  });

  it('sets the tabloBaseUrl', function () {
    expect(scope.tabloBaseUrl).toEqual(tabloBaseUrl);
  });
});