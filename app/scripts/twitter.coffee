'use strict'

class SocialTimeline.TwitterTimeline extends SocialTimeline.Timeline
  template: SocialTimeline.templates.twitter

  constructor: (@$el) ->
    @data = {}
    @data.widget_id = @get('widget-id')
    @data.username = @get('username')
    @data.show_head_follow = @get('show-head-follow')
    @data.width = @get('width', 250)
    @data.height = @get('height', 750)
    @data.limit = @get('limit')
    @data.chrome = null
    chrome_options =
      'noheader': 'true'
      'nofooter': 'true'
      'noborders': 'true'
      'noscrollbar': 'false'
      'transparent': 'false'
    selected_options = []
    for opt in Object.keys(chrome_options)
      data_opt = @get(opt, chrome_options[opt])
      data_opt = (data_opt == 'true')
      if data_opt
        selected_options.push(opt)
    chrome = selected_options.join(' ')
    if chrome.trim() != ''
      @data.chrome = chrome
    aria_polite = @get('aria-polite', true)
    if aria_polite
      @data.aria_polite = 'assertive'
    @render()

  render: ->
    if not @data.username? or not @data.widget_id?
      return
    @$el.html(@template(@data))
