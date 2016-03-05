somata = require 'somata'
async = require 'async'

client = new somata.Client

nameToTitle = (bookmark, cb) ->
    bookmark_update = {title: bookmark.name, name: null}
    client.remote 'curiosity:data', 'updateBookmark', bookmark._id, bookmark_update, cb

client.remote 'curiosity:data', 'findBookmarks', (err, bookmarks) ->
    async.map bookmarks, nameToTitle, ->
        console.log "Updated #{bookmarks.length} bookmarks"
        process.exit()

