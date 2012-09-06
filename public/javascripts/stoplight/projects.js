(function() {
  var $, Backbone, Collections, Models, _, _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  _ref = [this.Jquery, this._, this.Backbone, this.Stoplight.Models, this.Stoplight.Collections], $ = _ref[0], _ = _ref[1], Backbone = _ref[2], Models = _ref[3], Collections = _ref[4];

  Collections.Projects = (function(_super) {

    __extends(Projects, _super);

    function Projects() {
      return Projects.__super__.constructor.apply(this, arguments);
    }

    Projects.prototype.model = Models.Project;

    Projects.prototype.url = '/projects.json';

    Projects.prototype.failing_watched_projects = function() {
      return this.where({
        last_build_status: 'failed',
        ignored: false
      });
    };

    Projects.prototype.success = function() {
      return this.failing_watched_projects().length === 0;
    };

    return Projects;

  })(Backbone.Collection);

}).call(this);
