module.exports = load: ({deps: {Vue, mapState}}) ->
  Vue.component "bandcamp-audio",
    template: require('html-loader!./bandcamp-audio.slim')
