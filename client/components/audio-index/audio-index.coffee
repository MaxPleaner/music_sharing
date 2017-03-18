module.exports = load: ({deps: {Vue, mapState, Masonry, $}}) ->

  window.updateMasonry = ->
    window.masonry = new Masonry($("#audio-index")[0],
      itemSelector: ".audio"
      gutter: 20
    )

  Vue.component "audio-index",

    template: require('html-loader!./audio-index.slim')

    computed: mapState(['audios'])

    data: ->
      comments: @$store.state.comments
      tags: @$store.state.tags

    watch:
      comments: (val) ->
        updateMasonry()
      tags: (val) ->
        updateMasonry()

    mounted: ->( setTimeout ->
      updateMasonry()
    , 1000)

    methods:
      destroy_audio: (audio) ->
        @$store.dispatch "destroy_audio", id: audio.id
      updateMasonry: ->
