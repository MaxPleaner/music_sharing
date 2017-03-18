# ------------------------------------------------
# deps
# ------------------------------------------------

import Vue from 'vue'
import VueRouter from 'vue-router'
import Vuex from 'vuex'
Masonry = require 'masonry-layout'
mapState = Vuex.mapState
mapActions = Vuex.mapActions
$ = require 'jquery'
Cookies = require('cookies-js')
deps = {
  Vue, $, Vuex, mapState, mapActions, VueRouter, Cookies,
  Masonry
}

# ------------------------------------------------
# local files - the ordering should be preserved
# ------------------------------------------------

Object.assign deps,
  Client: require("./client")

Object.assign deps,
  CrudMapper: require("./lib/crud_mapper").load { deps }
Object.assign deps,
  Store: require('./lib/store').load { deps }
Object.assign deps,
  components: require('./components/components').load { deps }
Object.assign deps,
  root_constructor: require('./components/root/root').load { deps }  
Object.assign deps,
  Router: require('./lib/router').load { deps } 

# ------------------------------------------------
# Start client side app
# ------------------------------------------------

deps.pass = window.location.search.split("?pass=")[1]

window.LoadMusicSharing = ({deps}) ->

  server_health_url = if process.env["NODE_ENV"] == "production"
    "https://music-sharing.herokuapp.com/health"
  else
    "http://localhost:3000/health"

  $.get server_health_url, ->

    window.AppClient = new deps.Client({deps})
    AppClient.attach_vue_to_dom()
    AppClient.attach_stylesheet_to_dom()

    AppClient.Store.commit "DONE_LOADING", true

    AppClient.Store.dispatch("authenticate", {pass: deps.pass})
    .then (server_token) ->
      AppClient.Store.commit "SET_AUTHENTICATED", true
      AppClient.Store.commit "SET_SERVER_TOKEN", server_token
      AppClient.init_websockets()
    .catch (e) ->
      console.dir(e)
      AppClient.Store.commit "PUSH_ERROR", """
        Failed to authenticate.
        Please email maxpleaner@gmail.com for access
      """     


$ -> LoadMusicSharing({deps})

