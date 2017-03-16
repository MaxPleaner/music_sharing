module.exports = load: ({deps: {Vue, mapState}}) ->
  Vue.component "bandcamp-input",
    template: require('html-loader!./bandcamp-input.slim')
    methods:
      add_audio: (e) ->
        @$store.dispatch "create_audio",
          source: "bandcamp"
          url: e.target.value
  



