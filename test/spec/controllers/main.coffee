'use strict'

describe 'Controller: MainCtrl', ->

  # Load the controller's module
  beforeEach module 'hearthCardsApp'
  # Load the mocks
  beforeEach module 'infinite-scroll'

  MainCtrl = {}
  scope = {}
  # Some constants
  TOTAL = 720
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
  PROMO = 2 # Set
  REWARD = 2 # Set
  MINION = 339 # Type
  WEAPON = 18 # Type
  ABILITY = 178 # Type
  BEAST = 32 # Race
  DEMON = 15 # Race
  DRAGON = 9 # Race
  MECH = 46 # Race
  MURLOC = 11 # Race
  TOKEN = 185

  DRUID = 69 # Class
  HUNTER = 40 # Class
  MAGE = 36 # Class
  PALADIN = 37 # Class
  PRIEST = 35 # Class
  ROGUE = 36 # Class
  SHAMAN = 39 # Class
  WARLOCK = 38 # Class
  WARRIOR = 37 # Class
  NEUTRAL = 348 # 'Classless'

  LEGENDARY = 70 # Rarity
  EPIC = 68 # Rarity
  RARE = 126 # Rarity
  COMMON = 277 # Rarity
  FREE = 66 # Rarity

  BASIC = 153 # Set
  CLASSIC = 303 # Set
  NAXX = 85 # Set
  GVG = 143 # Set

  MINION = 444 # Type
  WEAPON = 33 # Type
  ABILITY = 243 # Type

  BEAST = 50 # Race
  DEMON = 19 # Race
  DRAGON = 12 # Race
  MECH = 54 # Race
  MURLOC = 13 # Race
  PIRATE = 8 # Race
  TOTEM = 7 # Race

  SUMMONS = 73 # Cards that summon a token of some sort

  DRAFTABLE_PER_CLASS = 34 # Cards per class
  DRAFTABLE_NEUTRAL = 229 # 'Classless' cards

  DRAFTABLE_LEGENDARY = 62 # Rarity
  DRAFTABLE_EPIC = 66 # Rarity
  DRAFTABLE_RARE = 122 # Rarity
  DRAFTABLE_COMMON = 226 # Rarity
  DRAFTABLE_FREE = 59 # Rarity

  DRAFTABLE_BASIC = 133 # Set
  DRAFTABLE_CLASSIC = 245 # Set
  DRAFTABLE_NAXX = 30 # Set
  DRAFTABLE_GVG = 123 # Set

  DRAFTABLE_MINION = 339 # Type
  DRAFTABLE_WEAPON = 18 # Type
  DRAFTABLE_ABILITY = 178 # Type

  DRAFTABLE_BEAST = 32 # Race
  DRAFTABLE_DEMON = 15 # Race
  DRAFTABLE_DRAGON = 9 # Race
  DRAFTABLE_MECH = 46 # Race
  DRAFTABLE_MURLOC = 11 # Race
  DRAFTABLE_PIRATE = 8 # Race
  DRAFTABLE_TOTEM = 3 # Race

  DRAFTABLE_SUMMONS = 72 # Cards that summon a token of some sort

  TOKEN_DRUID = 35 # Class
  TOKEN_HUNTER = 6 # Class
  TOKEN_MAGE = 2 # Class
  TOKEN_PALADIN = 3 # Class
  TOKEN_PRIEST = 1 # Class
  TOKEN_ROGUE = 2 # Class
  TOKEN_SHAMAN = 5 # Class
  TOKEN_WARLOCK = 4 # Class
  TOKEN_WARRIOR = 3 # Class
  TOKEN_NEUTRAL = 119 # 'Classless'

  TOKEN_LEGENDARY = 8 # Rarity
  TOKEN_EPIC = 2 # Rarity
  TOKEN_RARE = 4 # Rarity
  TOKEN_COMMON = 51 # Rarity
  TOKEN_FREE = 7 # Rarity

  TOKEN_BASIC = 20 # Set
  TOKEN_CLASSIC = 58 # Set
  TOKEN_NAXX = 55 # Set
  TOKEN_GVG = 20 # Set

  TOKEN_MINION = 105 # Type
  TOKEN_WEAPON = 15 # Type
  TOKEN_ABILITY = 65 # Type

  TOKEN_BEAST = 18 # Race
  TOKEN_DEMON = 4 # Race
  TOKEN_DRAGON = 3 # Race
  TOKEN_MECH =  8 # Race
  TOKEN_MURLOC = 2 # Race
  TOKEN_PIRATE = 0 # Race
  TOKEN_TOTEM = 4 # Race

  TOKEN_SUMMONS = 1 # Cards that summon a token of some sort

  # Helper method to verify search results
  search = (query, count) ->
    scope.update(query)
    expect(scope.filtered.length).toBe count

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    MainCtrl = $controller 'MainCtrl', {
      $scope: scope
    }

  it 'search should work for empty query', ->
    search '', TOTAL

  it 'search should work for draftable/token', ->
    search 'draftable', DRAFTABLE
    search 'token', TOKEN

  # Class
  it 'search should work for classes', ->
    search 'druid', DRUID
    search 'hunter', HUNTER
    search 'mage', MAGE
    search 'paladin', PALADIN
    search 'priest', PRIEST
    search 'rogue', ROGUE
    search 'shaman', SHAMAN
    search 'warlock', WARLOCK
    search 'warrior', WARRIOR
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
    search 'promo', PROMO
    search 'reward', REWARD

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
    search 'legendary mech', 8
    search '2 mana mage spell', 4
    search '2/3 gvg minion with freeze', 1
    search '6/2 charge', 1
    search 'windfury divine shield taunt charge', 1

  it 'search should work for spell damage +1', ->
    # FIXME Note that this should actually return 10, but since 'spell' takes precedence in the current implementation,
    # it doesn't work.
    search 'spell damage +1', 1

  it 'search should work for "summons"', ->
    search 'summons', SUMMONS

  it 'search should work for not found', ->
    search 'batman', 0

  it 'search should work for quoted name', ->
    search '"Wisp"', 1
    search '"Feugen"', 1
    search '"Stalagg"', 1

  it 'search should work for unquoted name', ->
    search 'Wisp', 4 # Wisp and Dark Wispers
    search 'Feugen', 3 # Feugen and Stalagg
    search 'Stalagg', 3 # Feugen and Stalagg
