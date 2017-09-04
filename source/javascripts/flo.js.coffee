#= require 'mustache/mustache'

$ ->
  $.fn.load_playlist = ->
    @each ->
      $el = $(@)
      pid = $el.data('playlist')
      tpl = $el.html()
      $el.empty()
      loader = $.get "https://www.googleapis.com/youtube/v3/playlistItems",
        playlistId: pid
        part: "contentDetails,snippet"
        key: "AIzaSyAiWUKjTrbJXaRW1ML-whzE4uKDzrnFLEE"
        maxResults: 10
      loader.done (data) =>
        # perhaps we should keep this old-school
        for item in data.items
          console.log "got video", item.snippet.title
          li = Mustache.render tpl,
            title: item.snippet.title.replace('Flo Show episode', 'Episode')
            description: item.snippet.description
            thumbnail: item.snippet.thumbnails.medium.url
            id: item.contentDetails.videoId
          $el.append li

  
  $('[data-playlist]').load_playlist()