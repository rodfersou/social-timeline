'use strict'

class SocialTimeline.FacebookTimeline20 extends SocialTimeline.Timeline
  template: SocialTimeline.templates.facebook20

  constructor: (@$el) ->
    @data = {}
    @data.username = @get('username')
    @data.show_head_follow = @get('show-head-follow')
    @data.width = @get('width', 250)
    @data.height = @get('height', 750)
    @data.colorscheme = @get('colorscheme', 'light')
    @data.show_faces = @get('show-faces', false)
    @data.header = @get('header', 'light')
    @data.stream = @get('stream', true)
    @data.show_border = @get('show-border', false)
    @render()

  render: ->
    if not @data.username?
      return
    @$el.html(@template(@data))
