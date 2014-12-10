'use strict'

describe 'Controller: MainCtrl', ->

  # Load the controller's module
  beforeEach module 'hearthCardsApp'
  # Load the mocks
  beforeEach module 'infinite-scroll'

  MainCtrl = {}
  scope = {}
  # Some constants
  DRAFTABLE = 535
  PER_CLASS = 34 # Cards per class
  NEUTRAL = 229 # 'Classless' cards
  LEGENDARY = 62 # Rarity
  EPIC = 66 # Rarity
  RARE = 122 # Rarity
  COMMON = 226 # Rarity
  FREE = 59 # Rarity
  BASIC = 133 # Set
  CLASSIC = 245 # Set
  NAXX = 30 # Set
  GVG = 123 # Set
  MINION = 339 # Type
  WEAPON = 18 # Type
  ABILITY = 178 # Type
  BEAST = 32 # Race
  DEMON = 15 # Race
  DRAGON = 9 # Race
  MECH = 46 # Race
  MURLOC = 11 # Race
  PIRATE = 8 # Race
  TOTEM = 3 # Race
  # Helper method to verify search results
  search = (query, count) ->
    scope.search(query)
    expect(scope.filtered.length).toBe count

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    MainCtrl = $controller 'MainCtrl', {
      $scope: scope
    }

  it 'search should work for initial load', ->
    expect(scope.filtered.length).toBe DRAFTABLE

  it 'search should work for empty query', ->
    search '', DRAFTABLE

  # Class
  it 'search should work for classes', ->
    for clazz in ["druid", "hunter", "mage", "paladin", "priest", "rogue", "shaman", "warlock", "warrior"]
      search clazz, PER_CLASS
    search 'neutral', NEUTRAL

  # Rarity
  it 'search should work for rarity', ->
    search 'legendary', LEGENDARY
    search 'epic', EPIC
    search 'rare', RARE
    search 'common', COMMON
    search 'free', FREE

  # Set
  it 'search should work for sets', ->
    search 'basic', BASIC
    search 'classic', CLASSIC
    search 'expert', CLASSIC
    search 'naxx', NAXX
    search 'gvg', GVG

  # Type
  it 'search should work for types', ->
    search 'minion', MINION
    search 'minions', MINION
    search 'weapon', WEAPON
    search 'weapons', WEAPON
    search 'spell', ABILITY
    search 'ability', ABILITY
    search 'abilities', ABILITY

  # Race
  it 'search should work for races', ->
    search 'beast', BEAST
    search 'beasts', BEAST
    search 'murloc', MURLOC
    search 'murlocs', MURLOC
    search 'pirate', PIRATE
    search 'pirates', PIRATE
    search 'demon', DEMON
    search 'demons', DEMON
    search 'mech', MECH
    search 'mechs', MECH
    search 'mechanical', MECH
    search 'dragon', DRAGON
    search 'dragons', DRAGON
    search 'totem', TOTEM
    search 'totems', TOTEM

  it 'search should work for some common queries', ->
    search 'legendary mech', 7
    search '2 mana mage spell', 4
    search '2/3 gvg minion with freeze', 1
    search '6/2 charge', 1
    search 'windfury divine shield taunt charge', 1

  it 'search should work for not found', ->
    search 'batman', 0
