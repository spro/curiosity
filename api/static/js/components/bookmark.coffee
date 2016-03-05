React = require 'react'

Bookmark = ({bookmark}) ->
    <div>
        <a href=bookmark.url>{bookmark.name}</a>
        <span className='domain'>{bookmark.domain}</span>
    </div>

module.exports = Bookmark
