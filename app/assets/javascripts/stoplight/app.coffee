[$, _, Backbone, Stoplight, Models, Collections, Views, App] = [@jQuery, @_, @Backbone, @Stoplight, @Stoplight.Models, @Stoplight.Collections, @Stoplight.Views, @Stoplight.App]

$(document).ready( ->
  App.projects = new Collections.Projects

  refresh_data = () ->
    App.projects.fetch()

  refresh_data()
  
  new Views.ProjectsBoard({collection: App.projects, el: $('#projects-board')})
  new Views.ProjectsList({collection: App.projects, el: $('#projects-list')})

  setInterval(refresh_data , 5000)
)
