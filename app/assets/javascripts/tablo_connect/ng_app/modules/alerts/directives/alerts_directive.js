(function (angular) {
  "use strict";

  angular.module('ac.alerts', [])
    .directive('acAlerts', [function () {
      return {
        restrict: 'E',
        replace: true,
        scope: '=',
        templateUrl: '/assets/tablo_connect/ng_app/modules/alerts/templates/alerts.html',
        controller: ['$scope', function ($scope) {
          $scope.closeAlert = function (index) {
            $scope.alerts.messages.splice(index, 1);
          };
        }]
      };
    }]);

})(window.angular);