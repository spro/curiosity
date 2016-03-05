somata = require 'somata'

client = new somata.Client

parseDomain = (url) ->
    if matched = url.match(/^https?:\/\/([^\/]+)\//)
        matched[1]

fillBookmark = (new_bookmark, cb) ->
    new_bookmark.domain = parseDomain new_bookmark.url
    cb null, new_bookmark

createBookmark = (new_bookmark, cb) ->
    fillBookmark new_bookmark, (err, new_bookmark) ->
        client.remote 'curiosity:data', 'createBookmark', new_bookmark, cb

new somata.Service 'curiosity:engine', {
    createBookmark
}
