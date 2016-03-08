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
    getInitialState: ->
        editing: false

    componentWillReceiveProps: (new_props) ->
        @setState editing: false

    delete: ->
        Dispatcher.deleteBookmark @props.bookmark._id

    addTag: (tag) ->
        Dispatcher.addTag @props.bookmark._id, tag

    deleteTag: (tag) ->
        Dispatcher.deleteTag @props.bookmark._id, tag

    openTag: (tag) ->
        browserHistory.push {query: {q: tag}}

    toggleEditing: ->
        @setState editing: !@state.editing

    openUrl: (e) ->
        if e.metaKey
            window.open @props.bookmark.url, '_blank'

    render: ->
        if @state.editing
            return <EditingBookmark bookmark=@props.bookmark onCancel=@toggleEditing />

        <div className='bookmark'>
            <div className='title'>
                <a onClick=@openUrl>{@props.bookmark.title || @props.bookmark.url}</a>
                <span className='domain'>{@props.bookmark.domain}</span>
                <div className='actions'>
                    <a onClick=@toggleEditing className='edit'>Edit</a>
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

EditingBookmark = React.createClass
    getInitialState: ->
        title: @props.bookmark.title
        url: @props.bookmark.url
        summary: @props.bookmark.summary

    changeTitle: (e) ->
        title = e.target.value
        @setState {title}

    changeUrl: (e) ->
        url = e.target.value
        @setState {url}

    changeSummary: (e) ->
        summary = e.target.value
        @setState {summary}

    doSave: ->
        Dispatcher.updateBookmark @props.bookmark._id, @state

    render: ->
        <div className='bookmark editing'>
            <div className='title'>
                <input value=@state.title onChange=@changeTitle />
                <div className='actions'>
                    <a onClick=@props.onCancel className='cancel'>Cancel</a>
                    <a onClick=@doSave className='save'>Save</a>
                </div>
            </div>
            <div className='details'>
                <input value=@state.url onChange=@changeUrl className='url' />
                <textarea value=@state.summary onChange=@changeSummary />
                <Tags tags=@props.bookmark.tags addTag=@addTag deleteTag=@deleteTag openTag=@openTag />
            </div>
        </div>

module.exports = Bookmark
