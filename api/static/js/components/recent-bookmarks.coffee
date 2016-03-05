React = require 'react'
Bookmark = require './bookmark'
Dispatcher = require '../dispatcher'

RecentBookmarks = React.createClass
    getInitialState: ->
        loading: true
        bookmarks: []

    componentDidMount: ->
        Dispatcher.findBookmarks().onValue @foundBookmarks
        Dispatcher.bookmarkCreated.onValue @createdBookmark
        Dispatcher.bookmarkDeleted.onValue @deletedBookmark

    foundBookmarks: (bookmarks) ->
        @setState {bookmarks, loading: false}

    createdBookmark: (bookmark) ->
        bookmarks = @state.bookmarks.concat [bookmark]
        @setState {bookmarks}

    deletedBookmark: (bookmark_id) ->
        bookmarks = @state.bookmarks.filter (b) -> b._id != bookmark_id
        @setState {bookmarks}

    render: ->
        if @state.loading
            <p className='bookmarks loading'>Loading...</p>
        else
            <div className='bookmarks'>
                {@state.bookmarks.map (bookmark, i) -> <Bookmark bookmark=bookmark key=i />}
            </div>

module.exports = RecentBookmarks
