somata = require 'somata'
mongo = require 'mongodb'

db = new mongo.Db(
    'curiosity',
    mongo.Server('localhost', 27017),
    safe: true
)

db.open()

findBookmarks = (cb) ->
    db.collection('bookmarks').find().toArray cb

createBookmark = (new_bookmark, cb) ->
    db.collection('bookmarks').insert new_bookmark, (err, inserted) ->
        cb err, inserted?.ops?[0] # Mongo driver insert response is weird

new somata.Service 'curiosity:data', {
    findBookmarks
    createBookmark
}
