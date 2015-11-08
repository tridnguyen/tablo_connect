(function(angular) {
  'use strict';

  angular.module('ac.tabloService', [])
      .service('tabloService', ['$http', '$timeout', 'alertsService', function ($http, $timeout, alertsService) {
        var movieData = [],
            showData = [],
            episodeData = [];

        return {
          getMovies: function () {
            return $http({
              url: '/tablo/movies',
              method: 'GET'
            }).success(function (data) {
              movieData = data.movies;
            });
          },
          movieData: function() {
            return movieData;
          },
          getShows: function () {
            return $http({
              url: '/tablo/shows',
              method: 'GET'
            }).success(function (data) {
              showData = data.shows;
            });
          },
          showData: function() {
            return showData;
          },
          getEpisodes: function (showName) {
            return $http({
              url: '/tablo/episodes/' + showName,
              method: 'GET'
            }).success(function (data) {
              episodeData = data.episodes;
            });
          },
          episodeData: function() {
            return episodeData;
          },
          copyRecording: function (tabloId, type) {
            return $http({
              url: '/tablo/copy/' + tabloId + '/' + type,
              method: 'GET'
            });
          },
          copyStatus: function (tabloId, type) {
            return $http({
              url: '/tablo/copy/' + tabloId + '/' + type + '/status',
              method: 'GET'
            });
          },
          initCopy: function (recording, type) {
            var self = this;

            self.copyRecording(recording.tablo_id, type)
                .success(function () {
                  recording.copy_status = 'in_progress';
                  $timeout(function () {
                    self.pollStatus(recording, type);
                  }, 5000);
                })
                .error(function () {
                  alertsService.addAlert('danger', 'There was an issue starting the copy process.');
                });
          },
          pollStatus: function (recording, type) {
            var self = this;

            self.copyStatus(recording.tablo_id, type)
                .success(function (res) {
                  if (res.copy_status === 'in_progress') {
                    $timeout(function () {
                      self.pollStatus(recording, type);
                    }, 5000);
                  } else {
                    recording.copy_status = res.copy_status;
                  }
                })
                .error(function () {
                  alertsService.addAlert('danger', 'There was an issue getting the copy status');
                });
          },
          initPollStatus: function (recordings, type) {
            var self = this;

            recordings.forEach(function (recording) {
              if (recording.copy_status === 'in_progress') {
                self.pollStatus(recording, type);
              }
            });
          }
        };
      }]);
})(window.angular);