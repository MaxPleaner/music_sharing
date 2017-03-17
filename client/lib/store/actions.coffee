module.exports = load: ({deps: {CrudMapper, $, Client}}) ->
  Object.assign (
    CrudMapper.add_store_actions
      resource: "audio"
  ), (
    CrudMapper.add_store_actions
      resource: "tag"
  ), (
    CrudMapper.add_store_actions
      resource: "comment"
  ), (
    CrudMapper.add_store_actions
      resource: "tagging"
  ), (

    # Both errors and notices are rendered by the "notices" component
    # and expire after a few seconds.

    add_errors: ({commit}, errors) ->
      for error in errors
        commit("PUSH_ERROR", error)
        setTimeout ->
          commit("SHIFT_ERROR")
        , 2500

    add_notice: ({commit}, notice) ->
      commit("PUSH_NOTICE", notice)
      setTimeout ->
        commit("SHIFT_NOTICE")
      , 2500

    authenticate: ({commit}, {pass}) ->
      new Promise (resolve, reject) =>
        $.ajax
          type: "POST",
          url: "#{Client.prototype.base_url}/authenticate"
          data: {pass}
          success: resolve
          error: reject

  )
