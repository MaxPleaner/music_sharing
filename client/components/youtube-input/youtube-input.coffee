module.exports = load: ({deps: {Vue, mapState}}) ->
  Vue.component "youtube-input",
    template: require('html-loader!./youtube-input.slim')



