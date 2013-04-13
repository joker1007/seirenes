Seirenes.IndexRoute = Ember.Route.extend
  redirect: ->
    @transitionToRouteWithParams('pasokaras.index', {page: 1})
