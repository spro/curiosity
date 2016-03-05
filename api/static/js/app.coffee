React = require 'react'
ReactDOM = require 'react-dom'

fetchJSON = (url) ->
    fetch(url).then (res) -> res.json()

App = React.createClass
    render: ->
        <div>
            <h1>Curiosity Browser</h1>
            <h2>Add a bookmark</h2>
            <h2>Recent bookmarks</h2>
            <RecentBookmarks />
            <h2>Recent tags</h2>
        </div>

RecentBookmarks = React.createClass
    getInitialState: ->
        loading: true
        bookmarks: []

    componentDidMount: ->
        fetchJSON('/bookmarks.json').then (bookmarks) =>
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

ReactDOM.render <App />, document.getElementById 'app'
