somata = require 'somata'

client = new somata.Client

parseDomain = (url) ->
    if matched = url.match(/^https?:\/\/([^\/]+)\//)
        matched[1]

createBookmark = (new_bookmark, cb) ->
    new_bookmark.domain = parseDomain new_bookmark.url
    client.remote 'curiosity:data', 'createBookmark', new_bookmark, cb

new somata.Service 'curiosity:engine', {
    createBookmark
}
