React = require 'react'

Bookmark = React.createClass
    render: ->
        <div className='bookmark'>
            <a href=@props.bookmark.url>{@props.bookmark.name}</a>
            <span className='domain'>{@props.bookmark.domain}</span>
        </div>

module.exports = Bookmark
