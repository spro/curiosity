Kefir = require 'kefir'

fetchJSON = (method, url, data) ->
    if method == 'post'
        fetch_options = {
            method: 'post',
            body: JSON.stringify(data)
            headers: 'Content-Type': 'application/json'
        }
    else
        fetch_options = {
            method: 'get',
        }
    fp = fetch(url, fetch_options).then (res) -> res.json()
    f$ = Kefir.fromPromise fp
    return f$

Dispatcher =
    findBookmarks: ->
        fetchJSON('get', '/bookmarks.json')

    createBookmark: (new_bookmark) ->
        fetchJSON('post', '/bookmarks.json', new_bookmark)

module.exports = Dispatcher
