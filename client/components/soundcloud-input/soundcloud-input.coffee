module.exports = load: ({deps: {Vue, mapState}}) ->
  Vue.component "soundcloud-input",
    template: require('html-loader!./soundcloud-input.slim')
    methods:
      add_audio: (e) ->
        @$store.dispatch "create_audio",
          source: "soundcloud"
          url: e.target.value
  


