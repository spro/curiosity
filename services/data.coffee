somata = require 'somata'
mongo = require 'mongodb'

db = new mongo.Db(
    'curiosity',
    mongo.Server('localhost', 27017),
    safe: true
)

db.open()

findBookmarks = (cb) ->
    db.collection('bookmarks').find().sort({_id: -1}).toArray cb

getBookmark = (bookmark_id, cb) ->
    query = {_id: mongo.ObjectID bookmark_id}
    db.collection('bookmarks').findOne query, cb

searchBookmarks = (q, cb) ->
    title_query = {title: {$regex: q, $options: 'i'}}
    summary_query = {summary: {$regex: q, $options: 'i'}}
    url_query = {url: {$regex: q, $options: 'i'}}
    tags_query = {tags: {$regex: q, $options: 'i'}}
    query = {$or: [title_query, summary_query, url_query, tags_query]}
    db.collection('bookmarks').find(query).sort({_id: -1}).toArray cb

createBookmark = (new_bookmark, cb) ->
    db.collection('bookmarks').insert new_bookmark, (err, inserted) ->
        cb err, inserted?.ops?[0] # Mongo driver insert response is weird

updateBookmark = (bookmark_id, bookmark_update, cb) ->
    query = {_id: mongo.ObjectID bookmark_id}
    db.collection('bookmarks').findAndModify query, null, {$set: bookmark_update}, {new: true}, (err, updated) ->
        cb err, updated?.value

tagBookmark = (bookmark_id, tag, cb) ->
    query = {_id: mongo.ObjectID bookmark_id}
    db.collection('bookmarks').update query, {$push: {tags: tag}}, cb

untagBookmark = (bookmark_id, tag, cb) ->
    query = {_id: mongo.ObjectID bookmark_id}
    db.collection('bookmarks').update query, {$pull: {tags: tag}}, cb

deleteBookmark = (bookmark_id, cb) ->
    query = {_id: mongo.ObjectID bookmark_id}
    db.collection('bookmarks').remove query, cb

getUser = (query, cb) ->
    if user_id = query._id
        query._id = mongo.ObjectID user_id
    db.collection('users').findOne query, cb

new somata.Service 'curiosity:data', {
    findBookmarks
    getBookmark
    searchBookmarks
    createBookmark
    updateBookmark
    deleteBookmark
    tagBookmark
    untagBookmark
    getUser
}
