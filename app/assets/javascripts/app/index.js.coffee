#= require json2
#= require jquery
#= require spine
#= require spine/manager
#= require spine/ajax
#= require spine/route

#= require_tree ./lib
#= require_self
#= require_tree ./models
#= require_tree ./controllers
#= require_tree ./views

class App extends Spine.Controller
  el: "body",


  constructor: ->
    super
    console.log(@el)
    # Initialize controllers:
    #  @append(@items = new App.Items)
    #  ...
    @navigate "/transactions"
    Spine.Route.setup()    

window.App = App

$(document).ready ->
  $.for "controller_dashboard", -> window.Application = new App()