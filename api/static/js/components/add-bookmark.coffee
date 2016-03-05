React = require 'react'
Dispatcher = require '../dispatcher'

validUrl = (url) ->
    url.match /^https?:\/\/[^.]+\.[^\/]+/

AddBookmark = React.createClass
    getInitialState: ->
        url: ''
        title: ''
        errors: null

    validate: ->
        if !@state.url
            @setState errors: url: "Enter a URL"
            return false
        else if !validUrl(@state.url)
            @setState errors: url: "Enter a valid URL"
            return false
        return true

    doCreate: (e) ->
        e.preventDefault()
        return if !@validate()

        new_bookmark =
            title: @state.title
            url: @state.url

        Dispatcher.createBookmark(new_bookmark).onValue =>
            @setState @getInitialState()

    changeUrl: (e) ->
        url = e.target.value
        @setState {url}

    changeTitle: (e) ->
        title = e.target.value
        @setState {title}

    render: ->
        <form onSubmit=@doCreate className='add-bookmark'>
            <div className='input'>
                <input value=@state.url placeholder='url' onChange=@changeUrl />
                {if @state.errors?.url
                    <span className='error'>{@state.errors.url}</span>}
            </div>
            <input value=@state.title placeholder='title' onChange=@changeTitle />
            <button>Add</button>
        </form>

module.exports = AddBookmark
