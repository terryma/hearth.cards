request = require('request')
cheerio = require('cheerio')
fs = require('fs')
_ = require('underscore')

# Example format
# done "id": "335-alakir-the-windlord",
# done "name": "Al'Akir the Windlord",
# done "type": "Minion",
# done "class": "Shaman",
# done "rarity": "Legendary",
# done "set": "Expert",
# done "text": "Windfury, Charge, Divine Shield, Taunt",
# done "img": "335-alakir-the-windlord.png",
# done "mana": "8",
# done "attack": "3",
# done "health": "5",
# "draftable": true
# done "isToken"
# done "race"
# "summons"

# How to update for new expansion:
# 1. Run coffee hearthpwn.coffee to fetch all card data and images
# 2. Run imagemin * . to minimize all images
# 3. Copy the output of cards.json to app/scripts/app.coffee
# 4. Copy minized images to app/images/
SET = 107 # League of Explorer
LAST_PAGE = 7

scrapeListing = (page, stop, callback, cards = {}) ->
  if page == stop
    callback(cards)
    return

  url = "http://www.hearthpwn.com/cards?display=1&filter-set=#{SET}&filter-unreleased=1&page=" + page
  console.log "Fetching data from #{url}"
  request url, (error, response, html) ->
    if !error
      $ = cheerio.load(html)
      $('#cards tbody tr').filter ->
        data = $(this)
        id = data.find('.col-name a').attr('href').trim().replace(/^\/cards\//, '')
        name = data.find('.col-name').text().trim()
        type = data.find('.col-type').text().trim()
        clazz = data.find('.col-class').text().trim()
        mana = data.find('.col-cost').text().trim()
        attack = data.find('.col-attack').text().trim()
        health = data.find('.col-health').text().trim()

        card = {}
        card.id = id if id
        card.name = name if name
        card.type = type if type
        card.class = clazz if clazz
        card.mana = mana if mana
        card.attack = attack if attack
        card.health = health if health
        cards[id] = card
        # console.log card
        return
    scrapeListing page + 1, stop, callback, cards
    return
  return

scrapeVisual = (page, stop, callback, cards = {}) ->
  if page == stop
    callback(cards)
    return

  url = "http://www.hearthpwn.com/cards?display=2&filter-set=#{SET}&filter-unreleased=1&page=" + page
  console.log "Fetching image from #{url}"
  request url, (error, response, html) ->
    if !error
      $ = cheerio.load(html)
      $('#cards tbody tr').filter ->
        data = $(this).find('td.visual-details-cell')
        current = data.children().first()
        id = current.find('a').attr('href').trim().replace(/^\/cards\//, '')

        image = $(this).find('td.visual-image-cell img').attr('src')
        console.log "Downloading #{image}"
        if not image
          return
        request(image).pipe(fs.createWriteStream("images/#{id}.png"))

        # Card text
        current = current.next()
        if current.is('p')
          text = current.text().trim()
          current = current.next()

        # ul
        type = ''
        rarity = ''
        set = ''
        clazz = ''
        race = ''
        isToken = false
        draftable = false
        if current.is('ul')
          current.children().each (i, elem) ->
            e = $(this)
            if e.text().match(/^Type/)
              type = e.find('a').text().trim()
            if e.text().match(/^Rarity/)
              rarity = e.find('a').text().trim()
            if e.text().match(/^Set/)
              set = e.find('a').text().trim()
            if e.text().match(/^Class/)
              clazz = e.find('a').text().trim()
            if e.text().match(/^Race/)
              race = e.find('a').text().trim()
            if e.text().match(/^Token/)
              isToken = true
            if e.text().match(/^Collectible/)
              draftable = true
        card = cards[id]
        # card.id = id if id
        card.text = text if text
        card.type = type if type
        card.rarity = rarity if rarity
        card.set = set if set
        card.class = clazz if clazz
        card.race = race if race
        card.img = "#{id}.png"
        card.isToken = true if isToken
        card.draftable = true if draftable
        cards[id] = card

        return
    scrapeVisual page + 1, stop, callback, cards
    return
  return

scrapeListing 1, LAST_PAGE, (cards) ->
  scrapeVisual(1, LAST_PAGE, (cards) ->
    # console.log _.values(cards).length
    cards = _.sortBy(_.values(cards), (card) -> card.id)
    fs.writeFile('cards.json', JSON.stringify(cards, null, 4))
  , cards)
