module.exports = load: ({deps: {Vue, mapState}}) ->
  Vue.component "audio-index",
    template: require('html-loader!./audio-index.slim')
    computed: mapState(['audios'])
