'use strict'

angular.module('hearthCardsApp')
  .controller 'MainCtrl', ($scope, $filter, $http) ->
    $scope.query = ''
    $http.get('/cards.json').success (data) ->
      $scope.cards = data
      $scope.shown = data
      s = 6
      $scope.rows = ( $scope.shown[i..i+s-1] for i in [0..$scope.shown.length - 1 ] by s)

    $scope.search = (query) ->
      $scope.shown = $filter('filter')($scope.cards, query)
      s = 6
      $scope.rows = ( $scope.shown[i..i+s-1] for i in [0..$scope.shown.length - 1 ] by s)

