(function (angular) {
  'use strict';

  angular.module('ac.tabloConnectApp')
      .controller('ShowsCtrl', ['$scope', 'tabloBaseUrl', 'tabloService', function ($scope, tabloBaseUrl, tabloService) {
        $scope.shows = tabloService.showData();
        $scope.tabloBaseUrl = tabloBaseUrl;
      }]);
})(window.angular);