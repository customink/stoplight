(function() {
  var $, Backbone, Collections, Models, Views, _, _ref,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  _ref = [this.jQuery, this._, this.Backbone, this.Stoplight.Models, this.Stoplight.Collections, this.Stoplight.Views], $ = _ref[0], _ = _ref[1], Backbone = _ref[2], Models = _ref[3], Collections = _ref[4], Views = _ref[5];

  Views.ProjectsList = (function(_super) {

    __extends(ProjectsList, _super);

    function ProjectsList() {
      this._renderProjectListItem = __bind(this._renderProjectListItem, this);

      this.render = __bind(this.render, this);
      return ProjectsList.__super__.constructor.apply(this, arguments);
    }

    ProjectsList.prototype.shortcuts = {
      't': '_toggleMiniProjects'
    };

    ProjectsList.prototype.initialize = function(options) {
      this.collection.on('reset', this.render);
      _.extend(this, new Backbone.Shortcuts);
      this.delegateShortcuts();
      if (localStorage && localStorage.getItem('hide-mini-projects') === 'true') {
        this._toggleMiniProjects();
      }
      return this.render();
    };

    ProjectsList.prototype.render = function() {
      this.$el.empty();
      this.collection.each(this._renderProjectListItem);
      return this;
    };

    ProjectsList.prototype._renderProjectListItem = function(item) {
      var view;
      view = new Views.ProjectListItem({
        model: item
      });
      return this.$el.append(view.render().el);
    };

    ProjectsList.prototype._toggleMiniProjects = function() {
      $('#projects-board').toggleClass('expanded');
      $(this.el).toggleClass('collapsed');
      if (localStorage) {
        return localStorage.setItem('hide-mini-projects', !!$(this.el).hasClass('collapsed'));
      }
    };

    return ProjectsList;

  })(Backbone.View);

}).call(this);
