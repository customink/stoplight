(function() {
  var MiniProjectsView, ProjectListItemView, ProjectSuccessTileView, ProjectTileView, StoplightView,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  ProjectListItemView = (function(_super) {

    __extends(ProjectListItemView, _super);

    function ProjectListItemView() {
      this.render = __bind(this.render, this);
      return ProjectListItemView.__super__.constructor.apply(this, arguments);
    }

    ProjectListItemView.prototype.tagName = 'div';

    ProjectListItemView.prototype.className = 'project-list-item';

    ProjectListItemView.prototype.template = _.template($('#tmpl-project-list-item').html());

    ProjectListItemView.prototype.render = function() {
      this.$el.html(this.template(this.model.toJSON()));
      return this.el;
    };

    return ProjectListItemView;

  })(Backbone.View);

  ProjectSuccessTileView = (function(_super) {

    __extends(ProjectSuccessTileView, _super);

    function ProjectSuccessTileView() {
      this.render = __bind(this.render, this);
      return ProjectSuccessTileView.__super__.constructor.apply(this, arguments);
    }

    ProjectSuccessTileView.prototype.tagName = 'div';

    ProjectSuccessTileView.prototype.className = 'wrapper';

    ProjectSuccessTileView.prototype.template = _.template($('#tmpl-project-success-tile').html());

    ProjectSuccessTileView.prototype.render = function() {
      this.$el.html(this.template({}));
      return this.el;
    };

    return ProjectSuccessTileView;

  })(Backbone.View);

  ProjectTileView = (function(_super) {

    __extends(ProjectTileView, _super);

    function ProjectTileView() {
      this.render = __bind(this.render, this);
      return ProjectTileView.__super__.constructor.apply(this, arguments);
    }

    ProjectTileView.prototype.tagName = 'div';

    ProjectTileView.prototype.className = 'wrapper';

    ProjectTileView.prototype.template = _.template($('#tmpl-project-tile').html());

    ProjectTileView.prototype.initialize = function(opts) {
      this.width = opts.width;
      return this.height = opts.height;
    };

    ProjectTileView.prototype.render = function() {
      this.$el.html(this.template(this.model.toJSON()));
      this.$el.css('width', "" + this.width + "%");
      this.$el.css('height', "" + this.height + "%");
      return this.el;
    };

    return ProjectTileView;

  })(Backbone.View);

  MiniProjectsView = (function(_super) {

    __extends(MiniProjectsView, _super);

    function MiniProjectsView() {
      this.render = __bind(this.render, this);
      return MiniProjectsView.__super__.constructor.apply(this, arguments);
    }

    MiniProjectsView.prototype.tagName = 'aside';

    MiniProjectsView.prototype.id = 'mini-projects';

    MiniProjectsView.prototype.render = function() {
      var _this = this;
      this.model.forEach(function(p) {
        var v;
        v = new ProjectListItemView({
          model: p
        });
        v.render();
        return _this.$el.append(v.el);
      });
      return this.el;
    };

    return MiniProjectsView;

  })(Backbone.View);

  StoplightView = (function(_super) {

    __extends(StoplightView, _super);

    function StoplightView() {
      this._setFontSizes = __bind(this._setFontSizes, this);

      this.render = __bind(this.render, this);

      this.initialize = __bind(this.initialize, this);
      return StoplightView.__super__.constructor.apply(this, arguments);
    }

    StoplightView.prototype.tagName = 'div';

    StoplightView.prototype.id = 'stoplight';

    StoplightView.prototype.initialize = function() {
      return $(window).on('resize', this._setFontSizes);
    };

    StoplightView.prototype.render = function() {
      var v;
      $('#mini-projects').empty();
      v = new MiniProjectsView({
        model: this.model,
        el: $('#mini-projects')
      });
      v.render();
      $('#projects-board').empty();
      v = new ProjectsBoardView({
        model: this.model,
        el: $('#projects-board')
      });
      v.render();
      return this._setFontSizes();
    };

    StoplightView.prototype._setFontSizes = function() {
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

    return StoplightView;

  })(Backbone.View);

  this.StoplightView = StoplightView;

}).call(this);
