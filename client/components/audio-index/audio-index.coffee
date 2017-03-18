module.exports = load: ({deps: {Vue, mapState, Masonry, $}}) ->

  window.updateMasonry = ->
    setTimeout ->
      window.masonry = new Masonry($("#audio-index")[0],
        itemSelector: ".audio"
        gutter: 20
      )
    , 1000

  Vue.component "audio-index",

    template: require('html-loader!./audio-index.slim')

    computed: mapState(['audios'])

    data: ->
      watched_comments: @$store.state.comments
      watched_tags: @$store.state.tags
      watched_audios: @$store.state.audios

    watch:
      watched_comments: (val) -> updateMasonry()
      watched_tags: (val) -> updateMasonry()
      watched_audios: (val) -> updateMasonry()

    mounted: -> updateMasonry()

    methods:
      destroy_audio: (audio) ->
        @$store.dispatch "destroy_audio", id: audio.id
