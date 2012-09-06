[$, _, Backbone, Models] = [@jQuery, @_, @Backbone, @Stoplight.Models]

class Models.Project extends Backbone.Model
  defaults: {
    last_build_time: "unknown"
  }

  initialize: (options) ->
    if localStorage
      ignoreMe = (localStorage.getItem(@get('build_url')))
      @set('ignored', ignoreMe is "true")

  toggleIgnore: ->
    newValue = not(@get('ignored'))
    localStorage.setItem(@get('build_url'), newValue) if localStorage
    @set('ignored', newValue)

  toJSON: ->
    hash = _.clone(@attributes)
    
    hash.ignored_klass =
      ((@get('ignored') and "ignored") or "watching")

    time = hash.last_build_time
    hash.human_last_build_time =
      if time? and time  isnt "unknown"
        $.timeago(hash.last_build_time)
      else
        "unknown"

    hash
