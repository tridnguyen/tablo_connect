(function(angular) {
  'use strict';

  angular.module('ac.tabloConnectApp', ['ngSanitize', 'ui.router', 'ac.alertsModule', 'ac.tabloSyncModule', 'ac.tabloService', 'ac.titleize', 'ac.url'])
      .config(['$stateProvider', '$urlRouterProvider', function ($stateProvider, $urlRouterProvider) {
        $urlRouterProvider.otherwise('/');

        $stateProvider
            .state('index', {
              url: '/',
              templateUrl: '/assets/tablo_connect/ng_app/templates/index.html',
              controller: 'HomeCtrl'
            })
            .state('movies', {
              url: '/movies',
              templateUrl: '/assets/tablo_connect/ng_app/templates/movies.html',
              controller: 'MoviesCtrl',
              resolve: ['tabloService', function (tabloService) {
                return tabloService.getMovies();
              }]
            })
            .state('shows', {
              url: '/shows',
              templateUrl: '/assets/tablo_connect/ng_app/templates/shows.html',
              controller: 'ShowsCtrl',
              resolve: ['tabloService', function (tabloService) {
                return tabloService.getShows();
              }]
            })
            .state('episodes', {
              url: '/episodes/:showName',
              templateUrl: '/assets/tablo_connect/ng_app/templates/episodes.html',
              controller: 'EpisodesCtrl',
              resolve: ['$stateParams', 'tabloService', function ($stateParams, tabloService) {
                return tabloService.getEpisodes($stateParams.showName);
              }]
            });
      }]);
})(window.angular);
