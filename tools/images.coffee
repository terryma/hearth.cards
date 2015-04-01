request = require('request')
cheerio = require('cheerio')
fs = require('fs')
_ = require('underscore')

scrapeVisual = (page, stop, callback, cards = {}) ->
  if page == stop
    callback()
    return

  request 'http://www.hearthpwn.com/cards?page=' + page, (error, response, html) ->
    if !error
      $ = cheerio.load(html)
      $('#cards tbody tr').filter ->
        data = $(this).find('td.visual-details-cell')
        current = data.children().first()
        id = current.find('a').attr('href').trim().replace(/^\/cards\//, '')

        image = $(this).find('td.visual-image-cell img').attr('src')
        request(image).pipe(fs.createWriteStream("images/#{id}.png"))

        return
    scrapeVisual page + 1, stop, callback
    return
  return


scrapeVisual(1, 11, () -> console.log "done!")
