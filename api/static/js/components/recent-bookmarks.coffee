React = require 'react'
Bookmark = require './bookmark'
Dispatcher = require '../dispatcher'

RecentBookmarks = React.createClass
    getInitialState: ->
        loading: true
        bookmarks: []

    componentDidMount: ->
        Dispatcher.findBookmarks().onValue @foundBookmarks
        Dispatcher.bookmarkAdded.onValue @addedBookmark

    foundBookmarks: (bookmarks) ->
        @setState {bookmarks, loading: false}

    addedBookmark: (bookmark) ->
        bookmarks = @state.bookmarks.concat [bookmark]
        @setState {bookmarks}

    render: ->
        if @state.loading
            <p className='bookmarks loading'>Loading...</p>
        else
            <div className='bookmarks'>
                {@state.bookmarks.map (bookmark, i) -> <Bookmark bookmark=bookmark key=i />}
            </div>

module.exports = RecentBookmarks
