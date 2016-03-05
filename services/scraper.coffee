somata = require 'somata'
request = require 'request'
cheerio = require 'cheerio'

getTitle = (url, cb) ->
    options =
        headers: 'User-Agent': 'Curiosity Scraper'

    request url, options, (err, resp, body) ->
        if err
            cb err
        else
            $ = cheerio.load(body)
            title = $('title').text()
            cb null, title

new somata.Service 'curiosity:scraper', {
    getTitle
}
