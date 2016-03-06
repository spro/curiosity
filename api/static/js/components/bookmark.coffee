React = require 'react'
Dispatcher = require '../dispatcher'

NewTag = React.createClass
    getInitialState: ->
        tag: ''

    changeTag: (e) ->
        tag = e.target.value
        @setState {tag}

    addTag: (e) ->
        e.preventDefault()
        if @state.tag
            @props.addTag @state.tag
            @setState @getInitialState()

    render: ->
        <form onSubmit=@addTag>
            <input value=@state.tag onChange=@changeTag placeholder="Add tag" />
        </form>

Tags = React.createClass
    addTag: (tag) ->
        Dispatcher.addTag @props.bookmark._id, tag

    render: ->
        <div className='tags'>
            {@props.bookmark.tags?.map (tag, i) ->
                <span className='tag' key=i>{tag}</span>
            }
            <NewTag addTag=@addTag />
        </div>

Bookmark = React.createClass
    delete: ->
        Dispatcher.deleteBookmark @props.bookmark._id

    render: ->
        <div className='bookmark'>
            <a href=@props.bookmark.url className='title'>{@props.bookmark.title || @props.bookmark.url}</a>
            <Tags bookmark=@props.bookmark />
            <span className='domain'>{@props.bookmark.domain}</span>
            <div className='actions'>
                <a onClick=@delete>Delete</a>
            </div>
        </div>

module.exports = Bookmark
