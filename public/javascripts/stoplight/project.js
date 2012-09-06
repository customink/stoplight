(function() {
  var $, Backbone, Models, _, _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  _ref = [this.jQuery, this._, this.Backbone, this.Stoplight.Models], $ = _ref[0], _ = _ref[1], Backbone = _ref[2], Models = _ref[3];

  Models.Project = (function(_super) {

    __extends(Project, _super);

    function Project() {
      return Project.__super__.constructor.apply(this, arguments);
    }

    Project.prototype.defaults = {
      last_build_time: "unknown"
    };

    Project.prototype.initialize = function(options) {
      var ignoreMe;
      if (localStorage) {
        ignoreMe = localStorage.getItem(this.get('build_url'));
        return this.set('ignored', ignoreMe === "true");
      }
    };

    Project.prototype.toggleIgnore = function() {
      var newValue;
      newValue = !(this.get('ignored'));
      if (localStorage) {
        localStorage.setItem(this.get('build_url'), newValue);
      }
      return this.set('ignored', newValue);
    };

    Project.prototype.toJSON = function() {
      var hash, time;
      hash = _.clone(this.attributes);
      hash.ignored_klass = (this.get('ignored') && "ignored") || "watching";
      time = hash.last_build_time;
      hash.human_last_build_time = (time != null) && time !== "unknown" ? $.timeago(hash.last_build_time) : "unknown";
      return hash;
    };

    return Project;

  })(Backbone.Model);

}).call(this);
