(function(angular) {
  'use strict';

  angular.module('ac.titleize', [])
      .filter('titleize', [function () {
        return function (string) {
          if (!!string) {
            string = string.replace(/[_-]/g, ' ').replace(/\w\S*/g, function (txt) {
              return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();
            });

            return string;
          }
        };
      }]);

})(window.angular);