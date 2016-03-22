polar = require 'polar'
somata = require 'somata'
jwt = require 'jwt-simple'

client = new somata.Client

jwt_secret = 'fdsafdsa'

getUser = (user_id, cb) ->
    client.remote 'curiosity:data', 'getUser', {_id: user_id}, cb

login_token = (req, res, next) ->
    if token = req.session?.token
        console.log '[login_token] has a token'
        user_id = jwt.decode token, jwt_secret
        getUser user_id, (err, user) ->
            res.locals.user = user
            next()
    else
        console.log '[login_token] no token'
        next()

requireUser = (req, res, next) ->
    if res.locals.user?
        next()
    else
        res.redirect '/login'

app = polar
    port: 4748
    debug: true
    session: secret: 'asdfasdf'
    middleware: [login_token]

app.get '/login', (req, res) ->
    res.render 'login'

app.get '/logout', (req, res) ->
    req.session.destroy ->
        res.redirect '/login'

app.post '/login.json', (req, res) ->
    password = req.body.password
    client.remote 'curiosity:data', 'getUser', {password}, (err, user) ->
        if user?
            token = jwt.encode user._id, jwt_secret
            req.session.token = token
            req.session.save (err) ->
                res.json success: true
        else
            res.json success: false, error: "Incorrect password"

app.get '/bookmarks.json', (req, res) ->
    client.remote 'curiosity:data', 'findBookmarks', (err, bookmarks) ->
        res.json bookmarks

app.get '/bookmarks/search.json', (req, res) ->
    q = req.query.q
    client.remote 'curiosity:data', 'searchBookmarks', q, (err, bookmarks) ->
        res.json bookmarks

app.get '/bookmarks/:bookmark_id.json', (req, res) ->
    bookmark_id = req.params.bookmark_id
    client.remote 'curiosity:data', 'getBookmark', bookmark_id, (err, bookmark) ->
        res.json bookmark

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

app.get '/', requireUser, (req, res) -> res.render 'app'
app.get '/:page', requireUser, (req, res) -> res.render 'app'

app.start()
