module.exports = load: ({deps: {Vue, mapState}}) ->
  Vue.component "audio-index",
    template: require('html-loader!./audio-index.slim')
    computed: mapState(['audios'])
    methods:
      destroy_audio: (audio) ->

        @$store.dispatch "destroy_audio", id: audio.id
