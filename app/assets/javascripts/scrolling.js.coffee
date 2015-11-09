shouldLoadMore = ->
  $(window).scrollTop() == $(document).height() - $(window).height()

@listenOnScroll = (onScrollCallback) ->
  $(window).scroll(->
    if shouldLoadMore()
      onScrollCallback()
  )
