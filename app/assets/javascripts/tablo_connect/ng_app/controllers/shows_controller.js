(function (angular) {
  'use strict';

  angular.module('ac.tabloConnectApp')
      .controller('ShowsCtrl', ['$scope', 'tabloService', function ($scope, tabloService) {
        $scope.shows = tabloService.showData();
      }]);
})(window.angular);