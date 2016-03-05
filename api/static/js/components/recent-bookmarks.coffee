React = require 'react'
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
                {@state.bookmarks.map @renderBookmark}
            </div>

    renderBookmark: (bookmark, i) ->
        <div key=i>
            <a href=bookmark.url>{bookmark.name}</a>
        </div>

module.exports = RecentBookmarks
