React = require 'react'
ReactDOM = require 'react-dom'

fetchJSON = (method, url, data) ->
    if method == 'post'
        fetch_options = {
            method: 'post',
            body: JSON.stringify(data)
            headers: 'Content-Type': 'application/json'
        }
    else
        fetch_options = {
            method: 'get',
        }
    fetch(url, fetch_options).then (res) -> res.json()

App = React.createClass
    render: ->
        <div>
            <h1>Curiosity Browser</h1>
            <h2>Add a bookmark</h2>
            <AddBookmark />
            <h2>Recent bookmarks</h2>
            <RecentBookmarks />
            <h2>Recent tags</h2>
        </div>

AddBookmark = React.createClass
    getInitialState: ->
        url: ''
        name: ''

    doCreate: (e) ->
        e.preventDefault()

        new_bookmark =
            name: @state.name
            url: @state.url

        fetchJSON('post', '/bookmarks.json', new_bookmark).then =>
            @setState @getInitialState()

    changeUrl: (e) ->
        url = e.target.value
        @setState {url}

    changeName: (e) ->
        name = e.target.value
        @setState {name}

    render: ->
        <form onSubmit=@doCreate>
            <input value=@state.url placeholder='url' onChange=@changeUrl />
            <input value=@state.name placeholder='name' onChange=@changeName />
            <button>Add</button>
        </form>

RecentBookmarks = React.createClass
    getInitialState: ->
        loading: true
        bookmarks: []

    componentDidMount: ->
        fetchJSON('get', '/bookmarks.json').then (bookmarks) =>
            @setState {bookmarks, loading: false}

    render: ->
        if @state.loading
            <p>Loading...</p>
        else
            <div>
                {@state.bookmarks.map @renderBookmark}
            </div>

    renderBookmark: (bookmark, i) ->
        <div key=i>
            <a href=bookmark.url>{bookmark.name}</a>
        </div>

ReactDOM.render <App />, document.getElementById 'app'
