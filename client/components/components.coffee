# Manifest of components - all should be required here

module.exports = load: ({deps}) ->
  navbar: require('./navbar/navbar.coffee').load {deps}
  notices: require("./notices/notices.coffee").load { deps }
  audios: require("./audios/audios.coffee").load { deps }
  comments: require("./comments/comments.coffee").load { deps }
  tags: require("./tags/tags.coffee").load { deps }
  "audio-input": require("./audio-input/audio-input.coffee").load { deps }
  "audio-index": require("./audio-index/audio-index.coffee").load { deps }
  "bandcamp-input": require("./bandcamp-input/bandcamp-input.coffee").load { deps }
  "soundcloud-input": require("./soundcloud-input/soundcloud-input.coffee").load { deps }
  "youtube-input": require("./youtube-input/youtube-input.coffee").load { deps }
  "custom-input": require("./custom-input/custom-input.coffee").load { deps }
