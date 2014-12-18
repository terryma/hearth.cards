angular.module('hearthCardsApp')
  .directive 'card', ($animate) ->
    templateUrl: 'views/card.html'
    replace: true
    restrict: 'E'
    scope:
      card: '='
    link: (scope, elem, attrs, ctrl) ->
      elem.find('img.card-img').bind 'load', ->
        scope.$apply ->
          scope.loaded = true
