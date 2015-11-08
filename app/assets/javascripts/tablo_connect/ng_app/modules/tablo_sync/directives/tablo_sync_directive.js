(function (angular) {
  'use strict';

  angular.module('ac.tabloSync', [])
      .directive('tabloSync', [function () {
        return {
          restrict: 'E',
          replace: true,
          templateUrl: '/assets/tablo_connect/ng_app/modules/tablo_sync/templates/tablo_sync.html',
          controller: ['$scope', 'tabloSyncService', 'alertsService', function ($scope, tabloSyncService, alertsService) {
            $scope.syncing = false;

            $scope.syncRecordings = function () {
              alertsService.clearAlerts();
              $scope.syncing = true;

              tabloSyncService.syncRecordings()
                  .then(function () {
                        alertsService.addAlert('success', 'Sync completed successfully.');
                      },
                      function () {
                        alertsService.addAlert('danger', 'There was an issue connecting to your tablo.');
                      })
                  .finally(function () {
                    $scope.syncing = false;
                  });
            };
          }]
        };
      }]);
})(window.angular);