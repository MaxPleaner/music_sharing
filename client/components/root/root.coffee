module.exports = load: ({deps: { Vue, Store, mapState }}) ->

  activate: ({Router, components}) ->
    new Vue(
      store: Store
      router: Router
      template: require('html-loader!./root.slim')
      computed: mapState ['done_loading', 'authenticated']
    )
