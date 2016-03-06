React = require 'react'

NewTag = React.createClass
    getInitialState: ->
        tag: ''

    changeTag: (e) ->
        tag = e.target.value
        @setState {tag}

    addTag: (e) ->
        e.preventDefault()
        if @state.tag
            @props.addTag @state.tag
            @setState @getInitialState()

    render: ->
        <form onSubmit=@addTag className='add-tag'>
            <input value=@state.tag onChange=@changeTag placeholder="Add tag" />
        </form>

Tags = ({tags, addTag, deleteTag}) ->
    <div className='tags'>
        {tags?.map (tag, i) ->
            <span className='tag' key=i>
                {tag}
                <a className='delete' onClick={-> deleteTag tag}>x</a>
            </span>
        }
        <NewTag addTag=addTag />
    </div>

module.exports = Tags
