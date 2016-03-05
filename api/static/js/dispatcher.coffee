Kefir = require 'kefir'
KefirBus = require 'kefir-bus'

fetchJSON = (method, url, data) ->
    if method == 'post'
        fetch_options = {
            method: 'post',
            body: JSON.stringify(data)
            headers: 'Content-Type': 'application/json'
        }
    else
        fetch_options = {
            method: method
        }
    fp = fetch(url, fetch_options).then (res) -> res.json()
    f$ = Kefir.fromPromise fp
    return f$

Dispatcher =
    findBookmarks: ->
        fetchJSON('get', '/bookmarks.json')

    createBookmark: (new_bookmark) ->
        fetchJSON('post', '/bookmarks.json', new_bookmark)
            .onValue (created_bookmark) ->
                Dispatcher.bookmarkAdded.emit created_bookmark

    deleteBookmark: (bookmark_id) ->
        fetchJSON('delete', "/bookmarks/#{bookmark_id}.json")

    bookmarkAdded: KefirBus()

module.exports = Dispatcher
