React = require 'react'
ReactDOM = require 'react-dom'

AddBookmark = require './components/add-bookmark'
SearchBookmarks = require './components/search-bookmarks'
ListBookmarks = require './components/list-bookmarks'

App = React.createClass
    render: ->
        <div>
            <h1>Curiosity Browser</h1>
            <AddBookmark />
            <SearchBookmarks />
            <ListBookmarks />
        </div>

ReactDOM.render <App />, document.getElementById 'app'
