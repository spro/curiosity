React = require 'react'
Bookmark = require './bookmark'
Dispatcher = require '../dispatcher'

RecentBookmarks = React.createClass
    getInitialState: ->
        loading: true
        bookmarks: []

    componentDidMount: ->
        Dispatcher.findBookmarks()
        Dispatcher.bookmarks$.onValue @setBookmarks

    setBookmarks: (bookmarks) ->
        @setState {bookmarks, loading: false}

    render: ->
        if @state.loading
            <p className='bookmarks loading'>Loading...</p>
        else
            <div className='bookmarks'>
                {@state.bookmarks.map (bookmark, i) -> <Bookmark bookmark=bookmark key=i />}
            </div>

module.exports = RecentBookmarks
