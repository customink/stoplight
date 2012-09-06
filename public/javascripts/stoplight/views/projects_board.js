(function() {
  var $, Backbone, Collections, Models, Views, _, _ref,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  _ref = [this.jQuery, this._, this.Backbone, this.Stoplight.Models, this.Stoplight.Collections, this.Stoplight.Views], $ = _ref[0], _ = _ref[1], Backbone = _ref[2], Models = _ref[3], Collections = _ref[4], Views = _ref[5];

  Views.ProjectsBoard = (function(_super) {

    __extends(ProjectsBoard, _super);

    function ProjectsBoard() {
      this._renderFailure = __bind(this._renderFailure, this);

      this.render = __bind(this.render, this);
      return ProjectsBoard.__super__.constructor.apply(this, arguments);
    }

    ProjectsBoard.prototype.initialize = function(options) {
      this.collection.on('change', this.render);
      this.collection.on('reset', this.render);
      $(window).on('resize', this._setFontSizes);
      return this.render();
    };

    ProjectsBoard.prototype.render = function() {
      this._setData();
      this.$el.empty();
      ((this._size > 0) && this._renderFailures()) || this._renderSuccess();
      this._setFontSizes();
      return this;
    };

    ProjectsBoard.prototype._setData = function() {
      this._failures = this.collection.failing_watched_projects();
      this._size = this._failures.length;
      return this._setDimensions();
    };

    ProjectsBoard.prototype._setDimensions = function() {
      var columnSplits, columns, rows, _ref1;
      columnSplits = [0, 3, 10, 21, this._size];
      columns = _(columnSplits.sort(function(a, b) {
        return a - b;
      })).indexOf(this._size);
      rows = Math.max(Math.ceil(this._size / columns), 1.0);
      return _ref1 = [100 / columns, 100 / rows], this._tile_width = _ref1[0], this._tile_height = _ref1[1], _ref1;
    };

    ProjectsBoard.prototype._setFontSizes = function() {
      return $.each($('#projects-board .project'), function(index, element) {
        var $a, $element, $h1, $p, maxCharacterWidth;
        $element = $(element);
        $h1 = $element.find('h1');
        $a = $h1.find('a');
        $p = $element.find('p');
        maxCharacterWidth = ($element.width() / $a.html().length) * 1.5;
        $h1.css({
          fontSize: Math.min($element.height() / 4.0, maxCharacterWidth),
          marginTop: $element.height() / 3.0
        });
        return $p.css({
          fontSize: parseInt($h1.css('fontSize')) / 4.0
        });
      });
    };

    ProjectsBoard.prototype._renderSuccess = function() {
      var view;
      view = new Views.SuccessTile();
      this.$el.append(view.render().el);
      return this;
    };

    ProjectsBoard.prototype._renderFailures = function() {
      _(this._failures).each(this._renderFailure);
      return this;
    };

    ProjectsBoard.prototype._renderFailure = function(failure) {
      var view;
      view = new Views.FailureTile({
        model: failure,
        width: this._tile_width,
        height: this._tile_height
      });
      return this.$el.append(view.render().el);
    };

    return ProjectsBoard;

  })(Backbone.View);

}).call(this);
