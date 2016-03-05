React = require 'react'
ReactDOM = require 'react-dom'

AddBookmark = require './components/add-bookmark'
RecentBookmarks = require './components/recent-bookmarks'

App = React.createClass
    render: ->
        <div>
            <h1>Curiosity Browser</h1>
            <h2>Add a bookmark</h2>
            <AddBookmark />
            <h2>Recent bookmarks</h2>
            <RecentBookmarks />
            <h2>Recent tags</h2>
        </div>

ReactDOM.render <App />, document.getElementById 'app'
