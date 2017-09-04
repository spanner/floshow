#= require 'mustache/mustache'

$ ->
  $.fn.plays_video = (opts={}) ->
    $player = $('#player')
    $mask = $('#mask')
    console.log "plays video", @, opts
    @click (e) ->
      e.preventDefault()
      $player.find('iframe').attr 'src', opts.url
      $player.find('h3').text opts.title
      $player.addClass('visible')
      $mask.addClass('visible')

  $.fn.hides_player = ->
    @click ->
      $('#player').removeClass('visible')
      $('#mask').removeClass('visible')

  $.fn.loads_playlist = ->
    @each ->
      $el = $(@)
      pid = $el.data('playlist')
      tpl = $el.html()
      $el.empty()
      loader = $.getJSON "https://www.googleapis.com/youtube/v3/playlistItems",
        playlistId: pid
        part: "contentDetails,snippet"
        key: "AIzaSyAiWUKjTrbJXaRW1ML-whzE4uKDzrnFLEE"
        maxResults: 10
      loader.done (data) =>
        for item in data.items
          video_id = item.contentDetails.videoId
          video_title = item.snippet.title
          li = Mustache.render tpl,
            title: video_title.replace('Flo Show episode', 'Episode')
            description: item.snippet.description
            thumbnail: item.snippet.thumbnails.medium.url
            id: video_id
            href: "https://youtu.be/#{video_id}"
          $li = $(li).appendTo $el
          $li.find('a').plays_video
            title: video_title
            url: "https://www.youtube.com/embed/#{video_id}?rel=0"



  $('[data-playlist]').loads_playlist()
  $('a.close').hides_player()
  $('#mask').hides_player()