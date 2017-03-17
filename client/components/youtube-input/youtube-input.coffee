module.exports = load: ({deps: {Vue, mapState}}) ->
  Vue.component "youtube-input",
    template: require('html-loader!./youtube-input.slim')
    methods:
      add_audio: (e) ->
        @$store.dispatch "create_audio",
          source: "youtube"
          video_id: e.target.value
  



