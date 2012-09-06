(function() {
  var $, Backbone, Collections, Models, Views, _, _ref,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  _ref = [this.jQuery, this._, this.Backbone, this.Stoplight.Models, this.Stoplight.Collections, this.Stoplight.Views], $ = _ref[0], _ = _ref[1], Backbone = _ref[2], Models = _ref[3], Collections = _ref[4], Views = _ref[5];

  Views.ProjectListItem = (function(_super) {

    __extends(ProjectListItem, _super);

    function ProjectListItem() {
      this.render = __bind(this.render, this);
      return ProjectListItem.__super__.constructor.apply(this, arguments);
    }

    ProjectListItem.prototype.tagName = 'div';

    ProjectListItem.prototype.className = 'project-list-item';

    ProjectListItem.prototype.events = {
      'click .project': '_toggleIgnore'
    };

    ProjectListItem.prototype.initialize = function(options) {
      return this.model.on('change:ignored', this.render);
    };

    ProjectListItem.prototype.template = _.template("<a href=\"#toggle-ignore\" class=\"project {{ last_build_status }} {{ current_status }} {{ ignored_klass }}\">\n  {{ name }}\n  <time class=\"last-build-time invisible\" datetime=\"{{ last_build_time }}\" title=\"{{ human_last_build_time }}\">\n    {{ human_last_build_time }}\n  </time>\n</a>");

    ProjectListItem.prototype.render = function() {
      this.$el.html(this.template(this.model.toJSON()));
      return this;
    };

    ProjectListItem.prototype._toggleIgnore = function(event) {
      event.preventDefault();
      return this.model.toggleIgnore();
    };

    return ProjectListItem;

  })(Backbone.View);

}).call(this);
