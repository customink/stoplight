class ProjectListItemView extends Backbone.View
  tagName: 'div'
  className: 'project-list-item'
  template:  _.template $('#tmpl-project-list-item').html()

  render:()=>
    @$el.html @template(@model.toJSON())
    @el

class ProjectSuccessTileView extends Backbone.View
  tagName: 'div'
  className: 'wrapper'
  template:  _.template $('#tmpl-project-success-tile').html()

  render: ()=>
    @$el.html @template({})
    @el

class ProjectTileView extends Backbone.View
  tagName: 'div'
  className: 'wrapper'
  template:  _.template $('#tmpl-project-tile').html()

  initialize: (opts)->
    @width = opts.width
    @height = opts.height

  render:()=>
    @$el.html @template(@model.toJSON())
    @$el.css 'width', "#{@width}%"
    @$el.css 'height', "#{@height}%"
    @el

class MiniProjectsView extends Backbone.View
  tagName: 'aside'
  id: 'mini-projects'

  render:()=>
    console.log "rendering miniprojects", @$el
    @model.forEach (p)=>
      v = new ProjectListItemView(model: p)
      v.render()
      @$el.append(v.el)
    @el

class ProjectsBoardView extends Backbone.View
  tagName: 'div'
  id: 'projects-board'

  render: ()=>
    console.log "rendering boards"
    failed_projects = @model.where last_build_status: 'failed'
    if failed_projects.length == 0
      v = new ProjectSuccessTileView
      @$el.html(v.render())
    else
      size = failed_projects.length
      columns = if size > 21 then 4.0
      else if size > 10 then 3.0
      else if size > 3 then 2.0
      else 1.0
      rows = Math.ceil(size / columns)
      rows = Math.max(rows, 1.0)

      w = 100.0 / columns
      h = 100.0 / rows
      failed_projects.forEach (p)=>
        v = new ProjectTileView(model: p, width: w, height: h)
        v.render()
        @$el.append(v.el)
    @el


class StoplightView extends Backbone.View
  tagName: 'div'
  id: 'stoplight'

  render: ()=>
    $('#mini-projects').empty()
    v = new MiniProjectsView model: @model, el: $('#mini-projects')
    v.render()
    $('#projects-board').empty()
    v = new ProjectsBoardView model: @model, el: $('#projects-board')
    v.render()
    setFontSizes()

