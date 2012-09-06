[$, _, Backbone, Models, Collections, Views] = [@jQuery, @_, @Backbone, @Stoplight.Models, @Stoplight.Collections, @Stoplight.Views]

class Views.SuccessTile extends Backbone.View
  tagName: 'div'
  className: 'wrapper'

  template: _.template(
    """
      <article class="project success">
        <h1>
          <a href="javascript:void();">&#x2713; Hooray!</a>
        </h1>
        <p class="status">All builds are passing!</p>
      </article>
    """)

  render: =>
    @$el.html(@template({}))

    this
