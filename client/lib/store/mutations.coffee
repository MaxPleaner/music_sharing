module.exports = load: ({deps: {Vue, CrudMapper}}) ->

  crud = Object.assign (
    CrudMapper.add_mutations
      resource: "audio"
  ), (
    CrudMapper.add_mutations
      resource: "comment"
  ), (
    CrudMapper.add_mutations
      resource: "tag"
  )

  errors = 
    PUSH_ERROR: (state, error) ->
      state.errors.push error
      Vue.set state, "errors", state.errors
    SHIFT_ERROR: (state) ->
      state.errors.shift()
      Vue.set state, "errors", state.errors

  notices =
    PUSH_NOTICE: (state, notice) ->
      state.notices.push notice
      Vue.set state, "notices", state.notices
    SHIFT_NOTICE: (state) ->
      state.notices.shift()
      Vue.set state, "notices", state.notices

  ui_state =
    CHANGE_SOURCE: (state, val) ->
      Vue.set state, 'source', val

  Object.assign(crud, errors, notices, ui_state)

