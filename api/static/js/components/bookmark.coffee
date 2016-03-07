React = require 'react'
{browserHistory} = require 'react-router'
Tags = require './tags'
Dispatcher = require '../dispatcher'

ExpandableSummary = React.createClass
    getInitialState: ->
        expanded: false

    toggleExpanded: ->
        @setState expanded: !@state.expanded

    render: ->
        text = @props.text
        if !@state.expanded
            text = text.split(' ')[..25].join(' ') + '...'

        <p className='summary'>
            {text} <a onClick=@toggleExpanded>{if @state.expanded then 'Less' else 'More'}</a>
        </p>

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
                {if @props.bookmark.summary
                    <ExpandableSummary text=@props.bookmark.summary />
                }
                <Tags tags=@props.bookmark.tags addTag=@addTag deleteTag=@deleteTag openTag=@openTag />
            </div>
        </div>

module.exports = Bookmark
