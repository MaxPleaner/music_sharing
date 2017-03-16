module.exports = load: ({deps: {Vue, mapState}}) ->
  Vue.component "comments",
    template: require('html-loader!./comments.slim')
    computed: mapState(['comments'])
    methods:
      create_comment: (e) ->
        @$store.dispatch("create_comment", text: e.target.value)
      delete_comment: (comment) ->
        @$store.dispatch("destroy_comment", id: comment.id)
      update_comment: (e, comment) ->
        text = e.currentTarget.value
        clone_to_update = Object.assign {}, comment
        @$store.dispatch("update_comment", Object.assign(clone_to_update, {text}))


