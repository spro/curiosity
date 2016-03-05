somata = require 'somata'
async = require 'async'

client = new somata.Client

parseDomain = (url) ->
    if matched = url.match(/^https?:\/\/([^\/]+)\//)
        matched[1]

setDomain = (bookmark, cb) ->
    bookmark_update = domain: parseDomain bookmark.url
    client.remote 'curiosity:data', 'updateBookmark', bookmark._id, bookmark_update, cb

client.remote 'curiosity:data', 'findBookmarks', (err, bookmarks) ->
    async.map bookmarks, setDomain, ->
        console.log "Updated #{bookmarks.length} bookmarks"
        process.exit()

