(function (angular) {
    'use strict';

    angular.module('ac.url', [])
        .filter('urlencode', [function () {
            return function (string) {
                if (!!string) {
                    return encodeURIComponent(string);
                }
            };
        }])
        .filter('urldecode', [function () {
            return function (string) {
                if (!!string) {
                    return decodeURIComponent(string);
                }
            };
        }])
        .filter('tabloBaseUrl', [function () {
            return function (tabloIp) {
                if (!!tabloIp) {
                    return 'http://' + tabloIp + ':18080';
                }
            };
        }]);

})(window.angular);