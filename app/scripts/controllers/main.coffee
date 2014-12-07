'use strict'

angular.element(document).ready ->
  $('input[autofocus]:visible:first').focus()

angular.module('hearthCardsApp')
  .controller 'MainCtrl', ($scope, $filter, $http) ->
    $scope.query = ''
    $http.get('/cards.json').success (data) ->
      $scope.cards = data
      $scope.shown = data

    $scope.search = (query) ->
      $scope.shown = $filter('filter')($scope.cards, query)

