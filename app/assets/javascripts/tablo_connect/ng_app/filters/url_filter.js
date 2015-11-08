(function(angular) {
  'use strict';

  angular.module('ac.url', [])
      .filter('urlencode', [function () {
        return function (string) {
          if (!!string) {
            return encodeURIComponent(string);
          }
        };
      }]).filter('urldecode', [function () {
        return function (string) {
          if (!!string) {
            return decodeURIComponent(string);
          }
        };
      }]);

})(window.angular);