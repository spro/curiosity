React = require 'react'
Dispatcher = require '../dispatcher'

Tags = React.createClass
    render: ->
        <div className='tags'>
            {@props.bookmark.tags?.map (tag) ->
                <span className='tag'>{tag}</span>
            }
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
