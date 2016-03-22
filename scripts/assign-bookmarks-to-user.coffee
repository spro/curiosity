somata = require 'somata'
async = require 'async'

client = new somata.Client

user_id = process.argv[2]
if !user_id?
    console.log "Usage: coffee assign-bookmarks-to-user.coffee [user_id]"
    process.exit()

assignBookmark = (bookmark, cb) ->
    bookmark_update = {user_id: user_id}
    client.remote 'curiosity:data', 'updateBookmark', bookmark._id, bookmark_update, cb

client.remote 'curiosity:data', 'findBookmarks', (err, bookmarks) ->
    async.map bookmarks, assignBookmark, ->
        console.log "Updated #{bookmarks.length} bookmarks"
        process.exit()

