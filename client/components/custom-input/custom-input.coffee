module.exports = load: ({deps: {Vue, mapState}}) ->
  Vue.component "custom-input",
    template: require('html-loader!./custom-input.slim')



