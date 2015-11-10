(function (angular) {
  'use strict';

  angular.module('ac.tabloConnectApp')
      .controller('MoviesCtrl', ['$scope', 'tabloService', 'alertsService', function ($scope, tabloService, alertsService) {
        $scope.movies = tabloService.movieData();
        $scope.alerts = alertsService.getAlerts();

        $scope.copyRecording = function (movie) {
          alertsService.clearAlerts();
          tabloService.initCopy(movie, 'movie');
        };

        tabloService.initPollStatus($scope.movies, 'movie');
      }]);
})(window.angular);