polar = require 'polar'
somata = require 'somata'

client = new somata.Client

app = polar port: 4748, debug: true

app.get '/', (req, res) -> res.render 'app'

app.get '/bookmarks.json', (req, res) ->
    client.remote 'curiosity:data', 'findBookmarks', (err, bookmarks) ->
        res.json bookmarks

app.get '/bookmarks/search.json', (req, res) ->
    q = req.query.q
    client.remote 'curiosity:data', 'searchBookmarks', q, (err, bookmarks) ->
        res.json bookmarks

app.post '/bookmarks.json', (req, res) ->
    new_bookmark =
        title: req.body.title
        url: req.body.url

    client.remote 'curiosity:engine', 'createBookmark', new_bookmark, (err, created_bookmark) ->
        res.json created_bookmark

app.put '/bookmarks/:bookmark_id.json', (req, res) ->
    bookmark_id = req.params.bookmark_id
    bookmark_update =
        title: req.body.title
        url: req.body.url
        summary: req.body.summary

    client.remote 'curiosity:data', 'updateBookmark', bookmark_id, bookmark_update, (err, updated_bookmark) ->
        res.json updated_bookmark

app.delete '/bookmarks/:bookmark_id.json', (req, res) ->
    bookmark_id = req.params.bookmark_id
    client.remote 'curiosity:data', 'deleteBookmark', bookmark_id, (err) ->
        res.json {ok: !err?}

app.post '/bookmarks/:bookmark_id/tags.json', (req, res) ->
    bookmark_id = req.params.bookmark_id
    tag = req.body.tag
    client.remote 'curiosity:data', 'tagBookmark', bookmark_id, tag, (err) ->
        res.json {ok: !err?}

app.delete '/bookmarks/:bookmark_id/tags/:tag.json', (req, res) ->
    bookmark_id = req.params.bookmark_id
    tag = req.params.tag
    client.remote 'curiosity:data', 'untagBookmark', bookmark_id, tag, (err) ->
        res.json {ok: !err?}

app.start()
