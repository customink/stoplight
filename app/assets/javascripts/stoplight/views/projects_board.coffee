[$, _, Backbone, Models, Collections, Views] = [@jQuery, @_, @Backbone, @Stoplight.Models, @Stoplight.Collections, @Stoplight.Views]

class Views.ProjectsBoard extends Backbone.View

  initialize: (options) ->
    @collection.on('change', @render)
    @collection.on('reset',  @render)

    $(window).on 'resize', @_setFontSizes

    @render()

  render: =>
    @_setData()

    @$el.empty()
    (((@_size > 0) and @_renderFailures()) or @_renderSuccess())
    @_setFontSizes()

    this

  _setData: ->
    @_failures = @collection.failing_watched_projects()
    @_size = @_failures.length

    @_setDimensions()

  _setDimensions: ->
    columnSplits = [0, 3, 10, 21, @_size]

    columns = _(columnSplits.sort((a,b)-> a - b)).indexOf(@_size)
    rows = Math.max(Math.ceil(@_size / columns), 1.0)

    [@_tile_width, @_tile_height] = [(100 / columns), (100 / rows)]

  _setFontSizes: ->
    $.each $('#projects-board .project'), (index, element) ->
      $element = $(element)
      $h1 = $element.find('h1')
      $a = $h1.find('a')
      $p = $element.find('p')

      # 1.5 is an arbitrary value that only makes sense for this font
      maxCharacterWidth = ($element.width() / $a.html().length) * 1.5
      $h1.css
        fontSize: Math.min($element.height() / 4.0, maxCharacterWidth)
        marginTop: $element.height() / 3.0

      $p.css fontSize: parseInt($h1.css('fontSize')) / 4.0

  _renderSuccess: ->
    view = new Views.SuccessTile()

    @$el.append(view.render().el)

    this

  _renderFailures: ->
    _(@_failures).each(@_renderFailure)

    this

  _renderFailure: (failure) =>
    view = new Views.FailureTile({model: failure, width: @_tile_width, height: @_tile_height})

    @$el.append(view.render().el)
