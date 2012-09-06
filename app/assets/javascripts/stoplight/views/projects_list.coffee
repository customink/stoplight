[$, _, Backbone, Models, Collections, Views] = [@jQuery, @_, @Backbone, @Stoplight.Models, @Stoplight.Collections, @Stoplight.Views]

class Views.ProjectsList extends Backbone.View

  shortcuts: {
    't':'_toggleMiniProjects'
  }

  initialize: (options) ->
    @collection.on('reset', @render)

    # extend Backbone Shortcuts
    _.extend(@, new Backbone.Shortcuts)
    @delegateShortcuts()

    @_toggleMiniProjects() if localStorage && localStorage.getItem('hide-mini-projects') == 'true'

    @render()

  render: =>
    @$el.empty()
    
    @collection.each(@_renderProjectListItem)
    
    @

  _renderProjectListItem: (item) =>
    view = new Views.ProjectListItem({model: item})
    @$el.append(view.render().el)

  _toggleMiniProjects: ->
    $('#projects-board').toggleClass('expanded')
    $(@el).toggleClass('collapsed')
    localStorage.setItem('hide-mini-projects', !!$(@el).hasClass('collapsed')) if localStorage
