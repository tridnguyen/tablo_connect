(function (angular) {
  'use strict';

  angular.module('ac.alertsService', [])
    .service('alertsService', [function () {
      var alerts = {messages: []};

      return {
        getAlerts: function () {
          return alerts;
        },
        addAlert: function (type, msg) {
          type = type === 'error' ? 'danger' : type;
          alerts.messages.push({type: type, msg: msg});
        },
        clearAlerts: function() {
          alerts.messages.length = 0;
        }
      };
  }]);

})(window.angular);