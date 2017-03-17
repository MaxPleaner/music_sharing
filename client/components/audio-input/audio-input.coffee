module.exports = load: ({deps: {Vue, mapState}}) ->

  Vue.component "audio-input",

    template: require('html-loader!./audio-input.slim')    

    computed: Object.assign (
      mapState(['source'])
    ), (
      bandcamp_is_selected: -> @$store.state.source == "bandcamp"
      youtube_is_selected: -> @$store.state.source == "youtube"
      soundcloud_is_selected: -> @$store.state.source == "soundcloud"
      # custom_is_selected: -> @$store.state.source == "custom"
    )

    methods:
      change_source: (e) ->
        AppClient.Store.commit "CHANGE_SOURCE", e.target.value
