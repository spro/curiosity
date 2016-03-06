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
            <div className='title'>
                <a href=@props.bookmark.url>{@props.bookmark.title || @props.bookmark.url}</a>
                <span className='domain'>{@props.bookmark.domain}</span>
                <div className='actions'>
                    <a onClick=@delete className='delete'>Delete</a>
                </div>
            </div>
            <div className='details'>
                <Tags tags=@props.bookmark.tags addTag=@addTag deleteTag=@deleteTag />
            </div>
        </div>

module.exports = Bookmark
