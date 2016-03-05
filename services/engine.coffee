somata = require 'somata'

client = new somata.Client

createBookmark = (new_bookmark, cb) ->
    client.remote 'curiosity:data', 'createBookmark', new_bookmark, cb

new somata.Service 'curiosity:engine', {
    createBookmark
}
