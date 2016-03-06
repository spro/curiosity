React = require 'react'
Bookmark = require './bookmark'
Dispatcher = require '../dispatcher'

SearchBookmarks = React.createClass
    getInitialState: ->
        q: ''

    doSearch: (e) ->
        e.preventDefault()
        Dispatcher.searchBookmarks(@state.q)

    changeQ: (e) ->
        q = e.target.value
        @setState {q}

    render: ->
        <form onSubmit=@doSearch className='search-bookmarks'>
            <input value=@state.q placeholder='q' onChange=@changeQ />
            <button>Search</button>
        </form>


module.exports = SearchBookmarks
