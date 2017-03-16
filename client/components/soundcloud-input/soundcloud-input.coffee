module.exports = load: ({deps: {Vue, mapState}}) ->
  Vue.component "soundcloud-input",
    template: require('html-loader!./soundcloud-input.slim')



