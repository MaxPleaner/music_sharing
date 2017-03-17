module.exports = load: ({deps: {Vue, mapState}}) ->
  Vue.component "tags",
    template: require('html-loader!./tags.slim')
    computed: mapState(['tags'])
