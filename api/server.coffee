polar = require 'polar'
somata = require 'somata'

client = new somata.Client

app = polar port: 4748, debug: true

app.get '/', (req, res) -> res.render 'app'

app.get '/bookmarks.json', (req, res) ->
    client.remote 'curiosity:data', 'findBookmarks', (err, bookmarks) ->
        res.json bookmarks

app.start()
