'use strict'

class SocialTimeline.GooglePlusTimeline extends SocialTimeline.Timeline
  template: SocialTimeline.templates.gplus

  constructor: (@$el) ->
    @data = {}
    @data.username = @get('username')
    @data.api_key = @get('api-key')
    @data.show_head_follow = @get('show-head-follow')
    @data.width = @get('width', 250)
    @data.height = @get('height', 750)
    @data.limit = @get('limit', 5)
    @render()

  render: ->
    if not @data.username? and not @data.api_key?
      return

    @$el.html(@template(@data))

    $('.gplus-feed', @$el).width(@data.width)
    $('.gplus-feed', @$el).height(@data.height)

    api = 'https://www.googleapis.com/plus/v1/people/'
    apiend = '/activities/public'
    fields = 'items(published,title,url,object(content,url,attachments(image(url))),actor(displayName,url,image(url)))'
    maxResults = @data.limit

    $.ajax(
        url: "#{api}#{@data.username}#{apiend}?key=#{@data.api_key}&fields=#{fields}&maxResults=#{maxResults}"
        crossDomain: true
        dataType: 'jsonp'
    ).done do (self=@) -> (data) ->
      html = ''
      $('.gplus-feed', self.$el).html('');
      for item in data.items
        m = moment(item.published)
        re = new RegExp('(\#.*?)([\ ,<\n])', 'g')
        content = item.object.content + ' '
        content = content.replace(
          re,
          (match, p1, p2) ->
            url = "https://plus.google.com/s/#{p1}/"
            return """
            <a class="gplus-hashtag"
               href="#{url}"
               target="_blank"
               alt="#{p1}">
              #{p1}
            </a>
            #{p2}
            """
        )
        image = ''
        if item?.object?.attachments.length > 0
          image = """
          <a class="gplus-image"
             target="_blank"
             href="#{item.object.url}">
            <img src="#{item.object.attachments[0].image.url}"
                 alt="#{item.title}" />
          </a>
          """
        html = """
        <div class="gplus-post">
          <div class="gplus-profile">
            <a class="gplus-profile-image"
               target="_blank"
               href="#{item.object.url}">
              <img src="#{item.actor.image.url}"
                   alt="Google Plus #{item.actor.displayName} image" />
            </a>
            <a class="gplus-profile-user"
               target="_blank"
               href="#{item.object.url}">
              #{item.actor.displayName}
            </a>
            <time class="gplus-profile-timeago"
                  datetime="#{m.format()}">
              #{m.fromNow()}
            </time>
          </div>
          <div class="gplus-text">
            #{content}
          </div>
          #{image}
        </div>
        """
        $('.gplus-feed', self.$el).append(html);
