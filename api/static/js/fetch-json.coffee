Kefir = require 'kefir'

fetchJSON = (method, url, data) ->
    if method in ['post', 'put']
        fetch_options = {
            method: method
            body: JSON.stringify(data)
            headers: 'Content-Type': 'application/json'
        }
    else
        fetch_options = {
            method: method
        }
    fp = fetch(url, fetch_options).then (res) -> res.json()
    f$ = Kefir.fromPromise fp
    return f$

module.exports = fetchJSON

