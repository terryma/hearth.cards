'use strict'

angular.element(document).ready ->
  $('input[autofocus]:visible:first').focus()

angular.module('hearthCardsApp')
  .controller 'MainCtrl', ($scope, $filter, $location, cards) ->

    # Number of cards we load per infinite-scroll cycle
    $scope.cardsPerLoad = 20

    # User entered search query. Get it from the url if it's there
    $scope.query = if $location.path()? then $location.path()[1..]

    # All the cards in the game. This is defined as a constant instead of loaded from a json file async to reduce
    # CloudFront/S3 roundtrips, as well as to take advantage of build time minification
    $scope.allCards = cards

    # Map all cards to be indexed by their id
    $scope.allCardsMap = cards.reduce (map, card) ->
      map[card.id] = card
      map
    , {}

    # $scope.tokens = (card for card in $scope.allCards when card.isToken?)

    # $scope.tokensMap = cards.reduce (map, card) ->
      # (map[summoner] ||= []).push card for summoner in card.summons if card.summons?
      # map
    # , {}

    # All the draftable cards. This is the starting point of our filtering. Sort all of them by mana cost initially
    $scope.draftable = _.sortBy (card for card in cards when card.draftable), (card) -> parseInt(card.mana)

    # The entire set of cards matching the search.
    $scope.filtered = []

    # The subset of filtered cards that we've shown to the user already. Infinite-scroll keeps appending more cards to
    # this set until the user has scrolled to the bottom of the page.
    $scope.shown = []

    # Called by infinite-scroll to load more cards outside the user's current viewport
    $scope.load = ->
      $scope.shown.push $scope.filtered[$scope.shown.length..$scope.shown.length+$scope.cardsPerLoad]...

    # Generate the css class for the percentage circle used to indicate the number of filtered results
    $scope.percentCircleCssClass = ->
      percent = Math.round($scope.filtered.length / $scope.draftable.length * 100)
      "c100 p#{percent} small center"

    # Shows detailed card info and related cards. Called when card is clicked or the only search result
    $scope.show = (card) ->
      $scope.query = card.name
      $scope.createNewHistoryRecord = true
      $scope.search($scope.query)

    # Handles translating independent keyword from the query into its corresponding search filters
    $scope.parseToken = (token, filters) ->
      # Handle some words that don't impact search results
      if /^with$/.test token
        return
      else if /^(0|[1-9]\d*)\/(0|[1-9]\d*)$/.test token
        # 2/3 for 2 attack 3 health
        pair = token.split('/')
        filters.attack.push pair[0]
        filters.health.push pair[1]
      else if /^druid$|^hunter|^mage$|^paladin$|^priest$|^rogue$|^shaman$|^warlock$|^warrior$|^neutral$/i.test token
        filters.class.push token
      else if /^minion[s]?$/i.test token
        filters.type.push 'Minion'
      else if /^weapon[s]?$/i.test token
        filters.type.push 'Weapon'
      else if /^spell[s]?$|^ability$|^abilities$/i.test token
        filters.type.push 'Ability'
      else if /^legendary$|^epic$|^rare$|^common$|^free$/i.test token
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
      else if /^basic$/i.test token
        filters.set.push 'Basic'
      else if /^expert|classic$/i.test token
        filters.set.push 'Expert'
      else if /^gvg$/i.test token
        filters.set.push 'Goblins vs Gnomes'
      else if /^naxx$/i.test token
        filters.set.push 'Curse of Naxxramas'
      else if /^secrets$/i.test token
        # special logic for "secrets", since it's in the card text and not a
        # category
        filters.text.push 'Secret'
      else if /^summons$/i.test token
        # special logic for "summons", shows all cards that summons something else
        filters.summons.push 'Summons'
      else
        filters.text.push token

    # Flag to indicate whether we should create a new history record or replacing the existing one
    $scope.createNewHistoryRecord = true

    # Flag to indicate whether the change in URL originated from a change in user input or from browser back/forward
    # buttons
    $scope.locationChangeFromSearch = false

    # Every time the url changes, we perform a search update
    $scope.$on '$locationChangeStart', (event) ->
      $scope.query = $location.path()[1..]
      $scope.update($scope.query)

    # Every time after a url change, we update our state flags to maintain sane browser history.
    $scope.$on '$locationChangeSuccess', (event) ->
      if !$scope.locationChangeFromSearch
        $scope.createNewHistoryRecord = true
      $scope.locationChangeFromSearch = false

    # Get a list of cards related to the current card
    $scope.related = (card) ->
      $scope.allCardsMap[cardId] for cardId in card.summons || []

    # Perform search based on user input from the search input text box.
    $scope.search = (query) ->
      # Instruct the history handler to not save every user keystroke into browser history
      $scope.locationChangeFromSearch = true
      $location.path("/" + query)
      $location.replace() if !$scope.createNewHistoryRecord
      $scope.createNewHistoryRecord = false

    # Perform search based on a query. Query can be user submitted from the search input, or from direct url changes.
    $scope.update = (query) ->
      filters =
        mana: []
        attack: []
        health: []
        class: []
        type: []
        rarity: []
        set: []
        race: []
        summons: []
        text: [] # This filters based on card name and card text

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
        # Can't have more than one value for each category here
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

          # Take care of the 'summons' keyword
          if filters.summons.length > 0
            return false if !value['summons']?

          # Filter based on card name and card text
          for text in filters.text
            regex = new RegExp(text.replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, "\\$&"), "i")
            if !regex.test(value.name) and !regex.test(value.text)
              return false
          return true

        )
        $scope.shown = $scope.filtered[0..$scope.cardsPerLoad-1]
