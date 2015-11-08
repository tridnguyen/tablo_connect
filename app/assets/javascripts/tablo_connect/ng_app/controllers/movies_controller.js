(function (angular) {
  'use strict';

  angular.module('ac.tabloConnectApp')
      .controller('MoviesCtrl', ['$scope', 'tabloService', 'tabloBaseUrl', 'alertsService', function ($scope, tabloService, tabloBaseUrl, alertsService) {
        $scope.movies = tabloService.movieData();
        $scope.alerts = alertsService.getAlerts();
        $scope.tabloBaseUrl = tabloBaseUrl;

        $scope.copyRecording = function (movie) {
          tabloService.initCopy(movie, 'movie');
        };

        tabloService.initPollStatus($scope.movies, 'movie');
      }]);
})(window.angular);