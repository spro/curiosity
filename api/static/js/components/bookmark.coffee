React = require 'react'
Dispatcher = require '../dispatcher'

Bookmark = React.createClass
    delete: ->
        Dispatcher.deleteBookmark @props.bookmark._id

    render: ->
        <div className='bookmark'>
            <a href=@props.bookmark.url className='title'>{@props.bookmark.title || @props.bookmark.url}</a>
            <span className='domain'>{@props.bookmark.domain}</span>
            <div className='actions'>
                <a onClick=@delete>Delete</a>
            </div>
        </div>

module.exports = Bookmark
