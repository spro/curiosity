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

updateBookmark = (bookmark_id, bookmark_update, cb) ->
    query = {_id: mongo.ObjectID bookmark_id}
    db.collection('bookmarks').update query, {$set: bookmark_update}, cb

tagBookmark = (bookmark_id, tag, cb) ->
    query = {_id: mongo.ObjectID bookmark_id}
    db.collection('bookmarks').update query, {$push: {tags: tag}}, cb

untagBookmark = (bookmark_id, tag, cb) ->
    query = {_id: mongo.ObjectID bookmark_id}
    db.collection('bookmarks').update query, {$pull: {tags: tag}}, cb

deleteBookmark = (bookmark_id, cb) ->
    query = {_id: mongo.ObjectID bookmark_id}
    db.collection('bookmarks').remove query, cb

new somata.Service 'curiosity:data', {
    findBookmarks
    createBookmark
    updateBookmark
    deleteBookmark
    tagBookmark
    untagBookmark
}
