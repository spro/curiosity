React = require 'react'
ReactDOM = require 'react-dom'
{Router, Route, IndexRoute, browserHistory} = require 'react-router'

Dispatcher = require './dispatcher'
AddBookmark = require './components/add-bookmark'
SearchBookmarks = require './components/search-bookmarks'
ListBookmarks = require './components/list-bookmarks'

App = React.createClass
    getInitialState: ->
        q: null

    componentDidMount: ->
        @loadBookmarks @props.location.query.q

    componentWillReceiveProps: (new_props) ->
        if new_props.location.pathname == '/'
            if new_props.location.query.q != @state.q
                @loadBookmarks new_props.location.query.q

    loadBookmarks: (q) ->
        @setState {q}, =>
            if @state.q
                Dispatcher.searchBookmarks(@state.q)
            else
                Dispatcher.findBookmarks()

    render: ->
        <div>
            <h1>Curiosity Browser</h1>
            <div className='row'>
                <AddBookmark />
                <SearchBookmarks q=@state.q />
            </div>
            <ListBookmarks />
            {@props.children}
        </div>

ShowBookmark = React.createClass
    getInitialState: ->
        depth: 0

    # Keep track of how many extra links have been loaded
    didLoad: ->
        @setState depth: @state.depth + 1

    goBack: ->
        browserHistory.go Math.min(-1 * @state.depth, -1)

    render: ->
        url = @props.location.query.url

        <div className='overlay'>
            <a onClick=@goBack className="close">&times;</a>
            <div className='content'>
                <iframe ref='iframe' src=url onLoad=@didLoad />
            </div>
        </div>

routes =
    <Route path='/' component=App>
        <Route path='/show' component=ShowBookmark />
    </Route>

ReactDOM.render <Router routes=routes history=browserHistory />, document.getElementById 'app'
