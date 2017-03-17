# ------------------------------------------------
# deps
# ------------------------------------------------

import Vue from 'vue'
import VueRouter from 'vue-router'
import Vuex from 'vuex'
mapState = Vuex.mapState
mapActions = Vuex.mapActions
$ = require 'jquery'
Cookies = require('cookies-js')
deps = { Vue, $, Vuex, mapState, mapActions, VueRouter, Cookies }

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

# If the server is deployed to Heroku, it could sleep.
# It gets pinged to awaken, and the page load is delayed
# until a response is set


$ ->

  server_health_url = if process.env["NODE_ENV"] == "production"
    "https://music-sharing.herokuapp.com/health"
  else
    "http://localhost:3000/health"

  $.get server_health_url, ->

    window.AppClient = new deps.Client({deps})
    AppClient.attach_vue_to_dom()
    AppClient.attach_stylesheet_to_dom()

    AppClient.Store.commit "DONE_LOADING", true

    pass = window.location.search.split("?pass=")[1]

    AppClient.Store.dispatch("authenticate", {pass})
    .then (server_token) ->
      AppClient.Store.commit "SET_AUTHENTICATED", true
      AppClient.Store.commit "SET_SERVER_TOKEN", server_token
      AppClient.init_websockets()
    .catch ->
      AppClient.Store.commit "PUSH_ERROR", """
        Failed to authenticate.
        Please email maxpleaner@gmail.com for access
      """     
