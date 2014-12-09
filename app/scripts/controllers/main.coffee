'use strict'

angular.element(document).ready ->
  $('input[autofocus]:visible:first').focus()

angular.module('hearthCardsApp')
  .controller 'MainCtrl', ($scope, $filter, cards) ->

    # Number of cards we load per infinite-scroll cycle
    $scope.cardsPerLoad = 20

    # User entered search query
    $scope.query = ''

    # All the cards in the game. This is defined as a constant instead of loaded from a json file async to reduce
    # CloudFront/S3 roundtrips, as well as to take advantage of build time minification
    $scope.allCards = cards

    # All the draftable cards. This is the starting point of our filtering. Sort all of them by mana cost initially
    $scope.draftable = _.sortBy (card for card in cards when card.draftable), (card) -> parseInt(card.mana)

    # The entire set of cards matching the search. This starts out being all the draftable cards
    $scope.filtered = $scope.draftable

    # The subset of filtered cards that we've shown to the user already. Infinite-scroll keeps appending more cards to
    # this set until the user has scrolled to the bottom of the page. Starts out with cardsPerLoad
    $scope.shown = $scope.filtered[0..$scope.cardsPerLoad-1]

    # Called by infinite-scroll to load more cards outside the user's current viewport
    $scope.load = ->
      $scope.shown.push $scope.filtered[$scope.shown.length..$scope.shown.length+$scope.cardsPerLoad]...

    # Called by orderBy to give the cards some default sorting. ATM we always sort by mana cost in ascending order
    # $scope.sort = (card) ->
      # return parseInt(card.mana)

    # TODO From here on out, clean up and document
    $scope.parseToken = (token, filters) ->
      # Handle some words that don't impact search results
      if /^with$/.test token
        return
      else if /^druid$|^hunter|^mage$|^paladin$|^priest$|^rogue$|^shaman$|^warlock$|^warrior$|^neutral$/i.test token
        filters.class.push token
      else if /^minion[s]?$/i.test token
        filters.type.push 'Minion'
      else if /^weapon[s]?$/i.test token
        filters.type.push 'Weapon'
      else if /^spell[s]?$|^ability$|^abilities$/i.test token
        filters.type.push 'Ability'
      else if /^legendary$|^epic$|^rare$|^common$/i.test token
        filters.rarity.push token
      else if /^beast[s]?$/i.test token
        filters.race.push 'Beast'
      else if /^demon[s]?$/i.test token
        filters.race.push 'Demon'
      else if /^dragon[s]?$/i.test token
        filters.race.push 'Dragon'
      else if /^mech[s]?$|^mechanical[s]?$/i.test token
        filters.race.push 'Mechanical'
      else if /^murloc[s]?$/i.test token
        filters.race.push 'Murloc'
      else if /^pirate[s]?$/i.test token
        filters.race.push 'Pirate'
      else if /^totem[s]?$/i.test token
        filters.race.push 'Totem'
      else if /^expert$/i.test token
        filters.set.push 'Expert'
      else if /^gvg$/i.test token
        filters.set.push 'Goblins vs Gnomes'
      else if /^naxx$/i.test token
        filters.set.push 'Curse of Naxxramas'
      else if /^secrets$/i.test token
        # special logic for "secrets", since it's in the card text and not a
        # category
        filters.text.push 'Secret'
      else
        filters.text.push token

    $scope.search = (query) ->
      filters =
        mana: []
        attack: []
        health: []
        class: []
        type: []
        rarity: []
        set: []
        race: []
        text: [] # this goes on name and card text

      tokens = query.split /\s+/
      cost = -1
      for token in tokens
        # Any number by itself is interpreted to be either mana, attack, or
        # health. This separates us from cases such as "+2 attack"
        if /^(0|[1-9]\d*)$/.test(token)
          # Save the cost and move to next token
          cost = parseInt(token)
        else
          # If we have a cost previously and the current token is  mana, attack,
          # or health
          if cost >= 0
            if /^mana$/i.test(token)
              filters.mana.push "#{cost}"
            else if /^attack[s]?$/i.test(token)
              filters.attack.push "#{cost}"
            else if /^health|durability$/i.test(token)
              filters.health.push "#{cost}"
            else
              # Cost didn't match with anything, "2 bananas" for example
              filters.text.push "#{cost}"
              $scope.parseToken(token, filters)
            cost = -1 # Reset the cost
          else
            # We don't have a cost previously
            $scope.parseToken(token, filters)

      # console.log ("#{type}: #{value}" for type, value of filters when value.length > 0)

      empty = false
      expression = {}
      for category in ['mana', 'attack', 'health', 'class', 'type', 'rarity', 'set', 'race']
        # can't have more than one value for each category here
        if filters[category].length > 1
          empty = true
          break
        else if filters[category].length == 1
          expression[category] = filters[category][0]

      if empty
        $scope.filtered = []
        $scope.shown = []
      else
        $scope.filtered = $filter('filter')($scope.draftable, (value, index) ->
          for category, input of expression
            # Special logic for 'neutral'
            if category == 'class' and input.toUpperCase() == 'NEUTRAL'
              return false if value[category]?
            else
              return false if !value[category]? or input.toUpperCase() != value[category].toUpperCase()

          # for any of text, if name or card text contains it
          for text in filters.text
            regex = new RegExp(text.replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, "\\$&"), "i")
            if !regex.test(value.name) and !regex.test(value.text)
              return false
          return true
        )
        $scope.shown = $scope.filtered[0..$scope.cardsPerLoad-1]

