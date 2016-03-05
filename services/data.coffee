somata = require 'somata'

bookmarks = [
    {_id: 1, url: 'http://prontotype.us/', name: 'Prontotype'}
    {_id: 2, url: 'http://areyoutryna.com/', name: 'Tryna'}
    {_id: 3, url: 'http://levelsolar.com/', name: 'Level Solar'}
]

findBookmarks = (cb) ->
    cb null, bookmarks

createBookmark = (new_bookmark, cb) ->
    new_bookmark._id = bookmarks.length + 1
    bookmarks.push new_bookmark
    cb null, new_bookmark

new somata.Service 'curiosity:data', {
    findBookmarks
    createBookmark
}
