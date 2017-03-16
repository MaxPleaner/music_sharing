module.exports = load: ({deps: {Vue, mapState}}) ->
  Vue.component "tags",
    template: require('html-loader!./tags.slim')
    computed: mapState(['tags'])
    methods:
      create_tag: (e) ->
        @$store.dispatch("create_tag", text: e.target.value)
      delete_tag: (tag) ->
        @$store.dispatch("destroy_tag", id: tag.id)
      update_tag: (e, tag) ->
        text = e.currentTarget.value
        clone_to_update = Object.assign {}, tag
        @$store.dispatch("update_tag", Object.assign(clone_to_update, {text}))


