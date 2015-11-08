describe('tabloSync directive', function () {
  'use strict';

  var $compile,
      $httpBackend,
      scope,
      element,
      tabloSyncService,
      alertsService;

  beforeEach(module('ngSanitize',
      'ac.tabloSyncModule',
      'ac.alertsModule',
      '/assets/tablo_connect/ng_app/modules/tablo_sync/templates/tablo_sync.html'
  ));

  beforeEach(inject(function (_$compile_, _$httpBackend_, $rootScope, _tabloSyncService_, _alertsService_) {
    $compile = _$compile_;
    $httpBackend = _$httpBackend_;
    tabloSyncService = _tabloSyncService_;
    alertsService = _alertsService_;
    scope = $rootScope.$new();
    element = $compile('<tablo-sync></tablo-sync>')(scope);
    scope.$digest();
  }));

  afterEach(function () {
    $httpBackend.verifyNoOutstandingExpectation();
    $httpBackend.verifyNoOutstandingRequest();
  });

  it('replaces the element with the tablo sync html', function () {
    expect(element.find('a').length).toBe(1);
  });

  it('sets $scope.syncing to false', function () {
    expect(scope.syncing).toBe(false);
  });

  describe('syncRecordings()', function () {
    beforeEach(function () {
      spyOn(alertsService, 'clearAlerts').and.callThrough();
      spyOn(tabloSyncService, 'syncRecordings').and.callThrough();
      $httpBackend.when('GET', '/tablo/sync').respond(200);
    });

    it('calls alertsService.clearAlerts()', function () {
      scope.syncRecordings();
      expect(alertsService.clearAlerts).toHaveBeenCalled();
      $httpBackend.flush();
    });

    it('sets $scope.syncing to true', function () {
      scope.syncRecordings();
      scope.$digest();
      expect(scope.syncing).toBe(true);
      expect(element.find('a').length).toBe(0);
      expect(element.find('p:eq(0)').text()).toContain('Sync in progress.');
      $httpBackend.flush();
    });

    it('calls tabloSyncService.syncRecordingings()', function () {
      scope.syncRecordings();
      expect(tabloSyncService.syncRecordings).toHaveBeenCalled();
      $httpBackend.flush();
    });
  });
});