somata = require 'somata'
request = require 'request'
cheerio = require 'cheerio'

scrape = (url, cb) ->
    options =
        headers: 'User-Agent': 'Curiosity Scraper'

    request url, options, (err, resp, body) ->
        if err
            cb err
        else
            $ = cheerio.load(body)

            title = $('title').text()

            if url.match /arxiv.org/
                summary = $('.abstract').text()
                summary = summary.trim().replace /\s+/g, ' '
                summary = summary.replace /^Abstract: /, ''

            cb null, {
                title
                summary
            }

new somata.Service 'curiosity:scraper', {
    scrape
}
