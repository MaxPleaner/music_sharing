module.exports = load: ({deps: {Vue, mapState}}) ->
  Vue.component "audios",
    template: require('html-loader!./audios.slim')



