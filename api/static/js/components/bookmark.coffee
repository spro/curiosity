React = require 'react'
Tags = require './tags'
Dispatcher = require '../dispatcher'

Bookmark = React.createClass
    delete: ->
        Dispatcher.deleteBookmark @props.bookmark._id

    addTag: (tag) ->
        Dispatcher.addTag @props.bookmark._id, tag

    deleteTag: (tag) ->
        Dispatcher.deleteTag @props.bookmark._id, tag

    render: ->
        <div className='bookmark'>
            <a href=@props.bookmark.url className='title'>{@props.bookmark.title || @props.bookmark.url}</a>
            <Tags tags=@props.bookmark.tags addTag=@addTag deleteTag=@deleteTag />
            <span className='domain'>{@props.bookmark.domain}</span>
            <div className='actions'>
                <a onClick=@delete>Delete</a>
            </div>
        </div>

module.exports = Bookmark
