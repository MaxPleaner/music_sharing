module.exports = load: ({ deps: { Vue, VueRouter, components } }) ->
  Vue.use VueRouter
  new VueRouter routes: [
    { path: '/', component: components.audios }
  ]

# Add a link in a view like so:
# router-link to='/' audios
#
# The '/' route is automatically shown
