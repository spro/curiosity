somata = require 'somata'

client = new somata.Client

parseDomain = (url) ->
    if matched = url.match(/^https?:\/\/([^\/]+)\//)
        matched[1]

fillBookmark = (new_bookmark, cb) ->
    new_bookmark.domain = parseDomain new_bookmark.url
    if new_bookmark.title
        cb null, new_bookmark
    else
        client.remote 'curiosity:scraper', 'getTitle', new_bookmark.url, (err, title) ->
            new_bookmark.title = title
            cb null, new_bookmark

createBookmark = (new_bookmark, cb) ->
    fillBookmark new_bookmark, (err, new_bookmark) ->
        client.remote 'curiosity:data', 'createBookmark', new_bookmark, cb

new somata.Service 'curiosity:engine', {
    createBookmark
}
