React = require 'react'
ReactDOM = require 'react-dom'
{Router, Route, IndexRoute, browserHistory} = require 'react-router'

Dispatcher = require './dispatcher'
AddBookmark = require './components/add-bookmark'
SearchBookmarks = require './components/search-bookmarks'
ListBookmarks = require './components/list-bookmarks'

App = React.createClass
    componentDidMount: ->
        if q = @props.location.query.q
            Dispatcher.searchBookmarks(q)
        else
            Dispatcher.findBookmarks()

    render: ->
        <div>
            <h1>Curiosity Browser</h1>
            <div className='row'>
                <AddBookmark />
                <SearchBookmarks q=@props.location.query.q />
            </div>
            <ListBookmarks />
        </div>

routes =
    <Route path='/' component=App />

ReactDOM.render <Router routes=routes history=browserHistory />, document.getElementById 'app'
