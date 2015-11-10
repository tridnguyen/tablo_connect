(function (angular) {
  'use strict';

  angular.module('ac.tabloConnectApp')
      .controller('EpisodesCtrl', ['$scope', '$stateParams', 'tabloService', 'alertsService', function ($scope, $stateParams, tabloService, alertsService) {
        $scope.episodes = tabloService.episodeData();
        $scope.showTitle = $stateParams.showName;
        $scope.alerts = alertsService.getAlerts();

        $scope.copyRecording = function (episodes) {
          alertsService.clearAlerts();
          tabloService.initCopy(episodes, 'show');
        };

        tabloService.initPollStatus($scope.episodes, 'show');
      }]);
})(window.angular);