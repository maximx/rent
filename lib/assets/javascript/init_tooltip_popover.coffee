@init_tooltip = () ->
  $('[data-toggle="tooltip"]').tooltip
    container: 'body'
    html: true

@init_popover = () ->
  $('[data-toggle="popover"]').popover
    html: true
  .click (e)->
    e.preventDefault()
