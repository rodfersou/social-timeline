'use strict'


class window.SocialTimeline
  constructor: (self=@)->
    ### jshint eqnull: true, eqeqeq: false, nonew: false ###
    ### break after hint ###

    locale = window.navigator.userLanguage || window.navigator.language
    moment.locale(locale)

    for el in $('.social-timeline')
      $el = $(el)
      $el.data('timeline', @get_timeline($el))

  get_timeline: ($el)->
    tl_types =
      twitter: SocialTimeline.TwitterTimeline
      facebook: SocialTimeline.FacebookTimeline23
      facebook20: SocialTimeline.FacebookTimeline20
      facebook23: SocialTimeline.FacebookTimeline23
      instagram: SocialTimeline.InstagramTimeline
      gplus: SocialTimeline.GooglePlusTimeline
    tl_type = $el.attr('data-type')
    if tl_type? and tl_type in Object.keys(tl_types)
      return new tl_types[tl_type]($el)


$ ->
  new SocialTimeline();
