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
            <p className='right'>Logged in as <strong>{user.username}</strong></p>
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
                    <MinimizedBookmark bookmark_id=minimized key=minimized />
                }
            </div>
        </div>

MinimizedBookmark = React.createClass
    contextTypes:
        location: React.PropTypes.object.isRequired

    getInitialState: ->
        loading: true
        bookmark: null

    componentDidMount: ->
        Dispatcher.getBookmark(@props.bookmark_id).onValue @setBookmark

    setBookmark: (bookmark) ->
        @setState {bookmark, loading: false}

    openBookmark: (e) ->
        if e.metaKey
            window.open @props.bookmark.url, '_blank'
        else
            query = @context.location.query
            query.min = forceArray(query.min).filter (bookmark_id) =>
                bookmark_id != @props.bookmark_id
            if query.overlay
                query.min.push query.overlay
            query.overlay = @props.bookmark_id
            browserHistory.push {query}

    render: ->
        <div className='bookmark'>
            {if @state.loading
                <span className='loading'>Loading...</span>
            else
                <a onClick=@openBookmark className='title' title=@state.bookmark.title>{@state.bookmark.title}</a>
            }
        </div>

BookmarkOverlay = React.createClass
    contextTypes:
        location: React.PropTypes.object.isRequired

    getInitialState: ->
        loading: true
        bookmark: null

    componentDidMount: ->
        Dispatcher.getBookmark(@props.bookmark_id).onValue @setBookmark

    componentWillReceiveProps: (new_props) ->
        if new_props.bookmark_id != @props.bookmark_id
            @setState {loading: true, bookmark: null}
            Dispatcher.getBookmark(new_props.bookmark_id).onValue @setBookmark

    setBookmark: (bookmark) ->
        @setState {bookmark, loading: false}

    doClose: ->
        query = @context.location.query
        delete query.overlay
        browserHistory.push {query}

    doMinimize: ->
        query = @context.location.query
        query.min = forceArray query.min
        query.min.push @props.bookmark_id
        delete query.overlay
        browserHistory.push {query}

    render: ->
        <div className='overlay'>
            <div className='actions'>
                <a onClick=@doClose>&times;</a>
                <a onClick=@doMinimize>-</a>
            </div>
            <div className='content'>
                {if @state.loading
                    <p className='loading'>Loading...</p>
                else
                    url = @state.bookmark.url
                    <iframe ref='iframe' src=url />
                }
            </div>
        </div>

routes =
    <Route path='/' component=App />

ReactDOM.render <Router routes=routes history=browserHistory />, document.getElementById 'app'
