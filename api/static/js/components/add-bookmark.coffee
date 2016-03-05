React = require 'react'
Dispatcher = require '../dispatcher'

AddBookmark = React.createClass
    getInitialState: ->
        url: ''
        name: ''

    doCreate: (e) ->
        e.preventDefault()

        new_bookmark =
            name: @state.name
            url: @state.url

        Dispatcher.createBookmark(new_bookmark).then =>
            @setState @getInitialState()

    changeUrl: (e) ->
        url = e.target.value
        @setState {url}

    changeName: (e) ->
        name = e.target.value
        @setState {name}

    render: ->
        <form onSubmit=@doCreate className='add-bookmark'>
            <input value=@state.url placeholder='url' onChange=@changeUrl />
            <input value=@state.name placeholder='name' onChange=@changeName />
            <button>Add</button>
        </form>

module.exports = AddBookmark
