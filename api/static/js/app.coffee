React = require 'react'
ReactDOM = require 'react-dom'

AddBookmark = require './components/add-bookmark'
RecentBookmarks = require './components/recent-bookmarks'

App = React.createClass
    render: ->
        <div>
            <h1>Curiosity Browser</h1>
            <AddBookmark />
            <RecentBookmarks />
        </div>

ReactDOM.render <App />, document.getElementById 'app'
