somata = require 'somata'
async = require 'async'

client = new somata.Client

scrapeSummary = (bookmark, cb) ->
    client.remote 'curiosity:scraper', 'scrape', bookmark.url, (err, scraped) ->
        bookmark_update = {summary: scraped.summary}
        client.remote 'curiosity:data', 'updateBookmark', bookmark._id, bookmark_update, cb

client.remote 'curiosity:data', 'searchBookmarks', 'arxiv.org', (err, bookmarks) ->
    async.map bookmarks, scrapeSummary, ->
        console.log "Updated #{bookmarks.length} bookmarks"
        process.exit()


