(function() {
  var $, App, Backbone, Collections, Models, Stoplight, Views, _, _ref;

  _ref = [this.jQuery, this._, this.Backbone, this.Stoplight, this.Stoplight.Models, this.Stoplight.Collections, this.Stoplight.Views, this.Stoplight.App], $ = _ref[0], _ = _ref[1], Backbone = _ref[2], Stoplight = _ref[3], Models = _ref[4], Collections = _ref[5], Views = _ref[6], App = _ref[7];

  $(document).ready(function() {
    var refresh_data;
    App.projects = new Collections.Projects;
    refresh_data = function() {
      return App.projects.fetch();
    };
    refresh_data();
    new Views.ProjectsBoard({
      collection: App.projects,
      el: $('#projects-board')
    });
    new Views.ProjectsList({
      collection: App.projects,
      el: $('#projects-list')
    });
    return setInterval(refresh_data, 5000);
  });

}).call(this);
