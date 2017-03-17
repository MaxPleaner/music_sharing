module.exports = load: ({deps}) ->
  errors: []
  notices: []
  audios: {}
  tags: {}
  taggings: {}
  comments: {}
  done_loading: false
  authenticated: false
  server_token: null
  source: null
