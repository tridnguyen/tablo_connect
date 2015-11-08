describe('alertsService', function () {
  'use strict';

  var $httpBackend,
      alertsService;

  beforeEach(module('ngSanitize',
      'ac.alertsService',
      '/assets/tablo_connect/ng_app/modules/alerts/templates/alerts.html'
  ));

  beforeEach(inject(function (_$httpBackend_, _alertsService_) {
    $httpBackend = _$httpBackend_;
    alertsService = _alertsService_;
  }));

  afterEach(function () {
    $httpBackend.verifyNoOutstandingExpectation();
    $httpBackend.verifyNoOutstandingRequest();
  });

  describe('getAlerts()', function () {
    it('returns the alerts', function () {
      expect(alertsService.getAlerts()).toEqual({messages: []});
    });
  });

  describe('addAlert()', function () {
    it('adds the alert to the alerts.messages array', function () {
      expect(alertsService.getAlerts()).toEqual({messages: []});
      alertsService.addAlert('success', 'In my experience there is no such thing as luck.');
      expect(alertsService.getAlerts()).toEqual({
        messages: [{
          type: 'success',
          msg: 'In my experience there is no such thing as luck.'
        }]
      });
    });
  });

  describe('getAlerts()', function () {
    it('returns the alerts', function () {
      alertsService.addAlert('success', 'In my experience there is no such thing as luck.');
      alertsService.addAlert('danger', 'I find your lack of faith disturbing.');
      expect(alertsService.getAlerts().messages.length).toEqual(2);
      alertsService.clearAlerts();
      expect(alertsService.getAlerts().messages.length).toEqual(0);
    });
  });

});