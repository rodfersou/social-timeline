'use strict'

class SocialTimeline.FacebookTimeline23 extends SocialTimeline.Timeline
  template: SocialTimeline.templates.facebook23

  constructor: (@$el) ->
    @data = {}
    @data.username = @get('username')
    @data.show_head_follow = @get('show-head-follow')
    @data.width = @get('width', 250)
    @data.height = @get('height', 750)
    @data.hide_cover = @get('hide-cover', true)
    @data.show_facepile = @get('show-facepile', false)
    @data.show_posts = @get('show-posts', true)
    @data.hide_cta = @get('hide-cta', true)
    @data.small_header = @get('small-header', true)
    @data.adapt_container_width = @get('adapt-container-width', true)
    @render()

  render: ->
    if not @data.username?
      return
    @$el.html(@template(@data))
