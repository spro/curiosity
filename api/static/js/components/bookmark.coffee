React = require 'react'
{browserHistory} = require 'react-router'
Tags = require './tags'
Dispatcher = require '../dispatcher'

Bookmark = React.createClass
    delete: ->
        Dispatcher.deleteBookmark @props.bookmark._id

    addTag: (tag) ->
        Dispatcher.addTag @props.bookmark._id, tag

    deleteTag: (tag) ->
        Dispatcher.deleteTag @props.bookmark._id, tag

    openTag: (tag) ->
        browserHistory.push {query: {q: tag}}

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
                <p className='summary'>{@props.bookmark.summary}</p>
                <Tags tags=@props.bookmark.tags addTag=@addTag deleteTag=@deleteTag openTag=@openTag />
            </div>
        </div>

module.exports = Bookmark
