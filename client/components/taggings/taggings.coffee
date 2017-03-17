module.exports = load: ({deps: {Vue, mapState}}) ->
  Vue.component "taggings",

    props: ['audio'] 
    
    template: require('html-loader!./taggings.slim')

    computed:
      taggings: ->
        Object.values(@$store.state.taggings).filter (tagging) =>
          tagging.audio_id == @audio.id
        .map (tagging) =>
          Object.assign {}, @$store.state.tags[tagging.tag_id], {id: tagging.id}
    methods:
      create_tagging: (e) ->
        @$store.dispatch "create_tagging",
          name: e.target.value,
          audio_id: @audio.id
      destroy_tagging: (id) ->
        @$store.dispatch "destroy_tagging", {id}

  
