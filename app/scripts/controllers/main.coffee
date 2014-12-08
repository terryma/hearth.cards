'use strict'

angular.element(document).ready ->
  $('input[autofocus]:visible:first').focus()

angular.module('hearthCardsApp')
  .controller 'MainCtrl', ($scope, $filter, $http) ->
    $scope.query = ''
    $http.get('/cards.json').success (cards) ->
      # Only show draftable cards now
      $scope.cards = (card for card in cards when card.draftable)
      $scope.shown = $scope.cards

    # called by orderBy
    $scope.sort = (card) ->
      return parseInt(card.mana)

    $scope.parseToken = (token, filters) ->
      if /^druid$|^hunter|^mage$|^paladin$|^priest$|^rogue$|^shaman$|^warlock$|^warrior$/i.test token
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
      cost = NaN
      for token in tokens
        tokenInt = parseInt(token)
        # Not a number
        if not tokenInt or !/^[1-9][0-9]*$/.test(token) # covers +2 attack
          # If we have a cost previously and current it's mana, attack, or
          # health
          if cost > 0
            if /^mana$/i.test(token)
              filters.mana.push "#{cost}"
            else if /^attack[s]?$/i.test(token)
              filters.attack.push "#{cost}"
            else if /^health$/i.test(token)
              filters.health.push "#{cost}"
            else
              # cost didn't match with anything, "a bananas" for example
              filters.text.push "#{cost}"
              $scope.parseToken(token, filters)
            cost = NaN # Empty out the cost
          else
            # We don't have a cost previously
            $scope.parseToken(token, filters)
        else
          # Save the cost and move to next token
          cost = tokenInt

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
        $scope.shown = []
      else
        $scope.shown = $filter('filter')($scope.cards, (value, index) ->
          for category, input of expression
            return false if !value[category]? or input.toUpperCase() != value[category].toUpperCase()

          # for any of text, if name or card text contains it
          for text in filters.text
            regex = new RegExp(text.replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, "\\$&"), "i")
            if !regex.test(value.name) and !regex.test(value.text)
              return false
          return true
        )

