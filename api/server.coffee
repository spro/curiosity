polar = require 'polar'
somata = require 'somata'

client = new somata.Client

app = polar port: 4748, debug: true

app.get '/', (req, res) -> res.render 'app'

app.get '/bookmarks.json', (req, res) ->
    client.remote 'curiosity:data', 'findBookmarks', (err, bookmarks) ->
        res.json bookmarks

app.post '/bookmarks.json', (req, res) ->
    new_bookmark =
        name: req.body.name
        url: req.body.url

    client.remote 'curiosity:engine', 'createBookmark', new_bookmark, (err, created_bookmark) ->
        res.json created_bookmark

app.delete '/bookmarks/:bookmark_id.json', (req, res) ->
    bookmark_id = req.params.bookmark_id
    client.remote 'curiosity:data', 'deleteBookmark', bookmark_id, (err) ->
        res.json {ok: !err?}

app.start()
