'use strict'

class SocialTimeline.InstagramTimeline extends SocialTimeline.Timeline
  template: SocialTimeline.templates.instagram

  constructor: (@$el) ->
    @data = {}
    @data.username = @get('username')
    @data.user_id = parseInt(@get('user-id'), 10)
    @data.access_token = @get('access-token')
    @data.show_head_follow = @get('show-head-follow')
    @data.width = @get('width', 250)
    @data.height = @get('height', 750)
    @data.limit = @get('limit', 5)
    SocialTimeline.instafeed_count = SocialTimeline.instafeed_count ?= 0
    SocialTimeline.instafeed_count += 1
    @data.instafeed_id = "instafeed-#{SocialTimeline.instafeed_count}"
    @render()
    $('.load-more', @$el).on('click', @, @load_more)

  render: ->
    if not @data.username? and not @data.user_id? and @data.user_id != NaN
      return

    @$el.html(@template(@data))

    $('.instagram-feed', @$el).width(@data.width)
    $('.instagram-feed', @$el).height(@data.height)

    load_button = $('.load-more', @$el)
    @feed = new Instafeed(
        get: 'user'
        userId: @data.user_id
        accessToken: @data.access_token
        target: @data.instafeed_id
        limit: @data.limit
        sortBy: 'most-recent'
        links: true
        resolution: 'low_resolution'
        template: """
        <div class="instagram-post">
          <div class="instagram-profile">
            <a class="instagram-profile-image"
               target="_blank"
               href="{{link}}">
              <img src="{{model.caption.from.profile_picture}}"
                   alt="Instagram {{model.caption.from.full_name}} image" />
            </a>
            <a class="instagram-profile-user"
               target="_blank"
               href="{{link}}">
              {{model.caption.from.full_name}}
            </a>
            <time class="instagram-profile-timeago"
                  datetime="{{model.created_time}}">
              {{model.created_time}}
            </time>
          </div>
          <div class="instagram-text">
            {{caption}}
          </div>
            <a class="instagram-image"
               target="_blank"
               href="{{link}}">
            <img src="{{image}}" />
          </a>
        </div>
        """
        after: do (self=@) -> () ->
          for time in $('.instagram-profile-timeago', self.$el)
            $time = $(time)
            m = moment.unix(parseInt($time.attr('datetime'), 10))
            $time.attr('datetime', m.format())
            $time.html(m.fromNow())
          for text in $('.instagram-text')
            $text = $(text)
            data = $text.html()
            re = new RegExp('(\#.*?)([\ ,<\n])', 'g')
            data = data + ' '
            data = data.replace(
              re,
              (match, p1, p2) ->
                tag_url = p1.substring(1).toLowerCase()
                url = "https://instagram.com/explore/tags/#{tag_url}/"
                return """
                <a class="instagram-hashtag"
                   href="#{url}"
                   target="_blank"
                   alt="#{p1}">
                  #{p1}
                </a>
                #{p2}
                """
            )
            $text.html(data)
          if not @hasNext()
            load_button.setAttribute('disabled', 'disabled')
    )
    @feed.run()

  load_more: (e) ->
    e.preventDefault()
    self = e.data
    self.feed.next()
