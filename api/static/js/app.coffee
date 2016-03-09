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
        show: null

    componentDidMount: ->
        query = @props.location.query
        @loadBookmarks query.q
        @showBookmark query.show

    componentWillReceiveProps: (new_props) ->
        query = new_props.location.query
        if query.q != @state.q
            @loadBookmarks query.q
        if query.show != @state.show
            @showBookmark query.show

    loadBookmarks: (q) ->
        @setState {q}, =>
            if @state.q
                Dispatcher.searchBookmarks(@state.q)
            else
                Dispatcher.findBookmarks()

    showBookmark: (show) ->
        @setState {show}

    render: ->
        <div>
            <h1>Curiosity Browser</h1>
            <div className='row'>
                <AddBookmark />
                <SearchBookmarks q=@state.q />
            </div>
            <ListBookmarks />
            {if @state.show
                <ShowBookmark bookmark_id=@state.show />
            }
        </div>

ShowBookmark = React.createClass
    getInitialState: ->
        loading: true
        bookmark: null
        depth: 0

    componentDidMount: ->
        Dispatcher.getBookmark(@props.bookmark_id).onValue @setBookmark

    setBookmark: (bookmark) ->
        @setState {bookmark, loading: false}

    # Keep track of how many extra links have been loaded
    didLoad: ->
        @setState depth: @state.depth + 1

    goBack: ->
        browserHistory.go Math.min(-1 * @state.depth, -1)

    render: ->
        <div className='overlay'>
            <a onClick=@goBack className="close">&times;</a>
            <div className='content'>
                {if @state.loading
                    <p className='loading'>Loading...</p>
                else
                    url = @state.bookmark.url
                    <iframe ref='iframe' src=url onLoad=@didLoad />
                }
            </div>
        </div>

routes =
    <Route path='/' component=App />

ReactDOM.render <Router routes=routes history=browserHistory />, document.getElementById 'app'
