React = require 'react'
{browserHistory} = require 'react-router'
KefirBus = require 'kefir-bus'
Bookmark = require './bookmark'
Dispatcher = require '../dispatcher'

SearchBookmarks = React.createClass
    getInitialState: ->
        q: @props.q || ''

    componentDidMount: ->
        @q$ = KefirBus()
        @q$.debounce(350).onValue @search

    componentWillReceiveProps: (new_props) ->
        @setState q: new_props.q

    search: (q) ->
        browserHistory.push {query: {q}}

    doSearch: (e) ->
        e.preventDefault()
        @search @state.q

    changeQ: (e) ->
        q = e.target.value
        @setState {q}, =>
            @q$.emit q

    render: ->
        <form onSubmit=@doSearch className='search-bookmarks'>
            <input value=@state.q placeholder='q' onChange=@changeQ />
            <button>Search</button>
        </form>

module.exports = SearchBookmarks
