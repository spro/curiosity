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

Store =
    bookmarks: []

Dispatcher =

    # Actions

    findBookmarks: ->
        fetchJSON('get', '/bookmarks.json')
            .onValue (bookmarks) ->
                Dispatcher.setBookmarks bookmarks

    createBookmark: (new_bookmark) ->
        fetchJSON('post', '/bookmarks.json', new_bookmark)
            .onValue (created_bookmark) ->
                Dispatcher.createdBookmark created_bookmark

    deleteBookmark: (bookmark_id) ->
        fetchJSON('delete', "/bookmarks/#{bookmark_id}.json")
            .onValue ->
                Dispatcher.deletedBookmark bookmark_id

    addTag: (bookmark_id, tag) ->
        fetchJSON('post', "/bookmarks/#{bookmark_id}/tags.json", {tag})
            .onValue ->
                Dispatcher.taggedBookmark bookmark_id, tag

    # Streams

    bookmarks$: KefirBus()

    # Stream logic

    setBookmarks: (bookmarks) ->
        Store.bookmarks = bookmarks
        Dispatcher.bookmarks$.emit bookmarks

    createdBookmark: (bookmark) ->
        bookmarks = Store.bookmarks.concat [bookmark]
        Dispatcher.setBookmarks bookmarks

    deletedBookmark: (bookmark_id) ->
        bookmarks = Store.bookmarks.filter (b) -> b._id != bookmark_id
        Dispatcher.setBookmarks bookmarks

    taggedBookmark: (bookmark_id, tag) ->
        bookmark = Store.bookmarks.filter((b) -> b._id == bookmark_id)[0]
        bookmark.tags ||= []
        bookmark.tags.push tag
        Dispatcher.setBookmarks Store.bookmarks

module.exports = Dispatcher
