React = require 'react'
ReactDOM = require 'react-dom'
{Router, Route, IndexRoute, browserHistory, Link} = require 'react-router'
fetchJSON = require './fetch-json'

Login = React.createClass
    getInitialState: ->
        email: ''
        password: ''
        error: null

    doLogin: (e) ->
        e.preventDefault()
        fetchJSON('post', '/login.json', {email: @state.email, password: @state.password})
            .onValue @didLogin

    didLogin: (response) ->
        if response.success
            window.location = '/'
        else
            @setState {error: response.error}

    changeEmail: (e) ->
        @setState {email: e.target.value}

    changePassword: (e) ->
        @setState {password: e.target.value}

    render: ->
        <div>
            <h2>Log in to Curiosity</h2>
            <form onSubmit=@doLogin className='login'>
                <input type='email' value=@state.email onChange=@changeEmail placeholder='Email' />
                <input type='password' value=@state.password onChange=@changePassword placeholder='Password' />
                {if @state.error
                    <span className='error'>{@state.error}</span>
                }
                <button>Log in</button>
            </form>
            <Link to='/signup'>Don't have an account?</Link>
        </div>

Signup = React.createClass
    getInitialState: ->
        username: ''
        email: ''
        password: ''
        error: null

    doSignup: (e) ->
        e.preventDefault()
        fetchJSON('post', '/signup.json', {username: @state.username, email: @state.email, password: @state.password})
            .onValue @didSignup

    didSignup: (response) ->
        if response.success
            window.location = '/'
        else
            @setState {error: response.error}

    changeUsername: (e) ->
        @setState {username: e.target.value}

    changeEmail: (e) ->
        @setState {email: e.target.value}

    changePassword: (e) ->
        @setState {password: e.target.value}

    render: ->
        <div>
            <h2>Sign up for Curiosity</h2>
            <form onSubmit=@doSignup className='signup'>
                <input value=@state.username onChange=@changeUsername placeholder='Username' />
                <input type='email' value=@state.email onChange=@changeEmail placeholder='Email' />
                <input type='password' value=@state.password onChange=@changePassword placeholder='Password' />
                {if @state.error
                    <span className='error'>{@state.error}</span>
                }
                <button>Sign up</button>
            </form>
            <Link to='/login'>Already have an account?</Link>
        </div>

App = React.createClass
    render: ->
        <div>
            <h1>Curiosity</h1>
            {@props.children}
        </div>

routes =
    <Route path='/' component=App>
        <Route path='/login' component=Login />
        <Route path='/signup' component=Signup />
    </Route>

ReactDOM.render <Router routes=routes history=browserHistory />, document.getElementById 'app'
