describe('acAlerts directive', function() {
  'use strict';

  var $compile,
      scope,
      element;

  beforeEach(module('ngSanitize',
      'ac.alerts',
      '/assets/tablo_connect/ng_app/modules/alerts/templates/alerts.html'
  ));

  beforeEach(inject(function(_$compile_, $rootScope){
    $compile = _$compile_;
    scope = $rootScope.$new();
  }));

  it('replaces the element with the alerts html', function() {
    element = $compile('<ac-alerts></ac-alerts>')(scope);
    scope.$digest();
    expect(element.attr('id')).toEqual('alerts');
  });

  describe('$scope.closeAlert()', function () {
    it('splices the alert from the alerts array', function() {
      scope.alerts = {messages: [
        {type: 'danger', msg: 'There was an error.'},
        {type: 'success', msg: 'Success!'}
      ]};
      element = $compile('<ac-alerts></ac-alerts>')(scope);
      scope.$digest();
      expect(element.find('.alert').length).toEqual(2);
      scope.closeAlert(0);
      scope.$digest();
      expect(element.find('.alert').length).toEqual(1);
      expect(element.find('.alert').text()).toContain('Success!');
    });
  });
});