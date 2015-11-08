(function(angular) {
  'use strict';

  angular.module('ac.tabloSyncService', [])
      .service('tabloSyncService', ['$http', function ($http) {
        var syncData = {};

        return {
          syncRecordings: function () {
            return $http({
              url: '/tablo/sync',
              method: 'GET'
            });
          },
          syncData: function() {
            return syncData;
          }
        };
      }]);
})(window.angular);