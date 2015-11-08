(function (angular) {
  'use strict';

  angular.module('ac.tabloConnectApp')
      .controller('HomeCtrl', ['$scope', 'alertsService', 'tabloSyncService', function ($scope, alertsService, tabloSyncService) {
        $scope.alerts = alertsService.getAlerts();
        $scope.syncData = tabloSyncService.syncData();
      }]);
})(window.angular);