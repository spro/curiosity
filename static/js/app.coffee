React = require 'react'
ReactDOM = require 'react-dom'

App = ->
    <div>
        <h1>Curiosity Browser</h1>
        <h2>Add a bookmark</h2>
        <h2>Recent bookmarks</h2>
        <h2>Recent tags</h2>
    </div>

ReactDOM.render <App />, document.getElementById 'app'
