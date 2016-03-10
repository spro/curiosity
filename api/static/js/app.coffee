React = require 'react'
ReactDOM = require 'react-dom'
{Router, Route, IndexRoute, browserHistory} = require 'react-router'
_ = require 'underscore'

Dispatcher = require './dispatcher'
AddBookmark = require './components/add-bookmark'
SearchBookmarks = require './components/search-bookmarks'
ListBookmarks = require './components/list-bookmarks'

forceArray = (i) ->
    if !i?
        []
    else if _.isArray(i)
        i
    else
        [i]

App = React.createClass
    getInitialState: ->
        q: null
        overlay: null
        minimized: []

    componentDidMount: ->
        query = @props.location.query
        @loadBookmarks query.q
        @showOverlay query.overlay
        @showMinimized forceArray query.min

    componentWillReceiveProps: (new_props) ->
        query = new_props.location.query
        if query.q != @state.q
            @loadBookmarks query.q
        if query.overlay != @state.overlay
            @showOverlay query.overlay
        if forceArray(query.min).join(',') != @state.minimized.join(',')
            @showMinimized forceArray query.min

    loadBookmarks: (q) ->
        @setState {q}, =>
            if @state.q
                Dispatcher.searchBookmarks(@state.q)
            else
                Dispatcher.findBookmarks()

    showOverlay: (bookmark_id) ->
        @setState {overlay: bookmark_id}

    showMinimized: (bookmark_ids) ->
        @setState {minimized: bookmark_ids}

    render: ->
        <div>
            <h1>Curiosity Browser</h1>
            <div className='row'>
                <AddBookmark />
                <SearchBookmarks q=@state.q />
            </div>
            <ListBookmarks />
            {if @state.overlay
                <BookmarkOverlay bookmark_id=@state.overlay />
            }
            <div className='minimized'>
                {@state.minimized.map (minimized) ->
                    <MinimizedBookmark bookmark_id=minimized />
                }
            </div>
        </div>

MinimizedBookmark = React.createClass
    getInitialState: ->
        loading: true
        bookmark: null

    componentDidMount: ->
        Dispatcher.getBookmark(@props.bookmark_id).onValue @setBookmark

    setBookmark: (bookmark) ->
        @setState {bookmark, loading: false}

    render: ->
        <div className='bookmark'>
            {if @state.loading
                <span className='loading'>Loading...</span>
            else
                <a className='title' title=@state.bookmark.title>{@state.bookmark.title}</a>
            }
        </div>

BookmarkOverlay = React.createClass
    contextTypes:
        location: React.PropTypes.object.isRequired

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

    doMinimize: ->
        query = @context.location.query
        query.min = forceArray query.min
        query.min.push @props.bookmark_id
        query.overlay = null
        browserHistory.push {query}

    render: ->
        <div className='overlay'>
            <div className='actions'>
                <a onClick=@goBack>&times;</a>
                <a onClick=@doMinimize>-</a>
            </div>
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
