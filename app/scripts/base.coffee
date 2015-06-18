'use strict'


class SocialTimeline.Timeline
  get: (attr, default_value=null) ->
    value = @$el.attr("data-#{attr}")
    if not value?
      value = default_value
    @$el.removeAttr("data-#{attr}")
    return value
