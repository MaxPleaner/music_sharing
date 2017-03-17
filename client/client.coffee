module.exports = class Client

# ------------------------------------------------
# Setup and private vars
# ------------------------------------------------

  prod_base_url = "music-sharing.herokuapp.com"
  dev_base_url = "localhost:3000"

  base_url = if process.env.NODE_ENV == "production" 
    "https://#{prod_base_url}"
  else
    "http://#{dev_base_url}"

  ws_base_url = if process.env.NODE_ENV == "production"
    "wss://#{prod_base_url}"
  else
    "ws://#{dev_base_url}"


# ------------------------------------------------
# The exported object
# ------------------------------------------------

  base_url: base_url

  ws_base_url: ws_base_url

  constructor: ({deps}) ->
    {
      @Cookies, @components, @root_constructor,
      @Router, @Store, @$, @CrudMapper
    } = deps
    @root = @root_constructor.activate({ @Router, @components })
    @anchor = @$("#vue-anchor")[0]
  
  attach_vue_to_dom: ->
    @root.$mount @anchor
    
  attach_stylesheet_to_dom: ->
    require("./style/app.sass")

  init_websockets: =>
    server_token = AppClient.Store.state.server_token
    @ws = new WebSocket "#{@ws_base_url}/ws?server_token=#{server_token}"
    @ws.onopen = @ws_onopen
    @ws.onmessage = @ws_onmessage
    @ws.onclose = @ws_onclose

  ws_onopen: =>
    @CrudMapper.get_indexes()
    @ws_connect_interval && clearInterval(@ws_connect_interval)
  
  ws_onmessage: (message) =>
    data = JSON.parse(message.data)
    @CrudMapper.process_ws_message(data)

  ws_onclose: (e) =>
    window.e = e
    @ws_connect_interval ||= setInterval =>
      @init_websockets()
    , 500
