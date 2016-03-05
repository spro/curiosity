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

    client.remote 'curiosity:data', 'createBookmark', new_bookmark, (err, created_bookmark) ->
        res.json created_bookmark

app.start()
