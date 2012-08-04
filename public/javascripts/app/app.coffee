v = new StoplightView(model:Projects)

refresh_data = ()->
  Projects.fetch success: ()->
    v.render()

render_all = ()->
  p = Projects.first()
  $('body').append(v.el)
  v.render()
  setInterval refresh_data, 5*1000

Projects.fetch success: render_all




