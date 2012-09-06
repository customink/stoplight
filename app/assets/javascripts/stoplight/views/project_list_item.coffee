[$, _, Backbone, Models, Collections, Views] = [@jQuery, @_, @Backbone, @Stoplight.Models, @Stoplight.Collections, @Stoplight.Views]

class Views.ProjectListItem extends Backbone.View
  tagName: 'div'
  className: 'project-list-item'

  events: {
   'click .project':'_toggleIgnore'
  }

  initialize: (options) ->
    @model.on('change:ignored', @render)

  template: _.template(
    """
      <a href="#toggle-ignore" class="project {{ last_build_status }} {{ current_status }} {{ ignored_klass }}">
        {{ name }}
        <time class="last-build-time invisible" datetime="{{ last_build_time }}" title="{{ human_last_build_time }}">
          {{ human_last_build_time }}
        </time>
      </a>
    """)

  render: =>
    @$el.html @template(@model.toJSON())
    @

  _toggleIgnore: (event) ->
    event.preventDefault()
    @model.toggleIgnore()
