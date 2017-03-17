module.exports = load: ({deps: {Vue, mapState}}) ->
  Vue.component "comments",
    template: require('html-loader!./comments.slim')
    computed:
      comments: ->
        Object.values(@$store.state.comments).filter (comment) =>
          comment.audio_id == @audio.id
    props: ['audio']
    methods:
      create_comment: (e) ->
        @$store.dispatch "create_comment",
          audio_id: @audio.id
          content: e.target.value
      destroy_comment: (id) ->
        @$store.dispatch "destroy_comment", {id}


