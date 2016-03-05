React = require 'react'
Bookmark = require './bookmark'
Dispatcher = require '../dispatcher'

RecentBookmarks = React.createClass
    getInitialState: ->
        loading: true
        bookmarks: []

    componentDidMount: ->
        Dispatcher.findBookmarks().then (bookmarks) =>
            @setState {bookmarks, loading: false}

    render: ->
        if @state.loading
            <p>Loading...</p>
        else
            <div>
                {@state.bookmarks.map (bookmark, i) -> <Bookmark bookmark=bookmark key=i />}
            </div>

module.exports = RecentBookmarks
