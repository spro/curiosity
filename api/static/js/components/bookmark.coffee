React = require 'react'

Bookmark = ({bookmark}) ->
    <div>
        <a href=bookmark.url>{bookmark.name}</a>
    </div>

module.exports = Bookmark
