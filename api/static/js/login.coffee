React = require 'react'
ReactDOM = require 'react-dom'
fetchJSON = require './fetch-json'

Login = React.createClass
    getInitialState: ->
        password: ''
        error: null

    doLogin: (e) ->
        e.preventDefault()
        fetchJSON('post', '/login.json', {password: @state.password})
            .onValue @didLogin

    didLogin: (response) ->
        if response.success
            window.location = '/'
        else
            @setState {error: response.error}

    changePassword: (e) ->
        @setState {password: e.target.value}

    render: ->
        <div>
            <h1>Log in to Curiosity</h1>
            <form onSubmit=@doLogin className='login'>
                <input value=@state.password onChange=@changePassword placeholder='Password' />
                {if @state.error
                    <span className='error'>{@state.error}</span>
                }
                <button>Log in</button>
            </form>
        </div>

ReactDOM.render <Login />, document.getElementById 'app'
