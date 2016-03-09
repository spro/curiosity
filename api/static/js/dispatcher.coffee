Kefir = require 'kefir'
KefirBus = require 'kefir-bus'

fetchJSON = (method, url, data) ->
    if method in ['post', 'put']
        fetch_options = {
            method: method
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

    getBookmark: (bookmark_id) ->
        fetchJSON('get', "/bookmarks/#{bookmark_id}.json")

    createBookmark: (new_bookmark) ->
        fetchJSON('post', '/bookmarks.json', new_bookmark)
            .onValue (created_bookmark) ->
                Dispatcher.createdBookmark created_bookmark

    updateBookmark: (bookmark_id, bookmark_update) ->
        fetchJSON('put', "/bookmarks/#{bookmark_id}.json", bookmark_update)
            .onValue (updated_bookmark) ->
                Dispatcher.updatedBookmark bookmark_id, updated_bookmark

    deleteBookmark: (bookmark_id) ->
        fetchJSON('delete', "/bookmarks/#{bookmark_id}.json")
            .onValue ->
                Dispatcher.deletedBookmark bookmark_id

    addTag: (bookmark_id, tag) ->
        fetchJSON('post', "/bookmarks/#{bookmark_id}/tags.json", {tag})
            .onValue ->
                Dispatcher.taggedBookmark bookmark_id, tag

    deleteTag: (bookmark_id, tag) ->
        fetchJSON('delete', "/bookmarks/#{bookmark_id}/tags/#{tag}.json", {tag})
            .onValue ->
                Dispatcher.untaggedBookmark bookmark_id, tag

    searchBookmarks: (q) ->
        fetchJSON('get', '/bookmarks/search.json?q=' + encodeURIComponent q)
            .onValue (bookmarks) ->
                Dispatcher.setBookmarks bookmarks

    # Streams

    bookmarks$: KefirBus()

    # Stream logic

    setBookmarks: (bookmarks) ->
        Store.bookmarks = bookmarks
        Dispatcher.bookmarks$.emit bookmarks

    createdBookmark: (bookmark) ->
        Store.bookmarks.unshift bookmark
        Dispatcher.setBookmarks Store.bookmarks

    deletedBookmark: (bookmark_id) ->
        bookmarks = Store.bookmarks.filter (b) -> b._id != bookmark_id
        Dispatcher.setBookmarks bookmarks

    updatedBookmark: (bookmark_id, updated_bookmark) ->
        bookmark = Store.bookmarks.filter((b) -> b._id == bookmark_id)[0]
        for k, v of updated_bookmark
            bookmark[k] = updated_bookmark[k]
        Dispatcher.setBookmarks Store.bookmarks

    taggedBookmark: (bookmark_id, tag) ->
        bookmark = Store.bookmarks.filter((b) -> b._id == bookmark_id)[0]
        bookmark.tags ||= []
        bookmark.tags.push tag
        Dispatcher.setBookmarks Store.bookmarks

    untaggedBookmark: (bookmark_id, tag) ->
        bookmark = Store.bookmarks.filter((b) -> b._id == bookmark_id)[0]
        bookmark.tags = bookmark.tags?.filter (t) -> t != tag
        Dispatcher.setBookmarks Store.bookmarks

module.exports = Dispatcher
