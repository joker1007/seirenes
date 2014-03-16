Seirenes.IndexRoute = Ember.Route.extend
  redirect: ->
    @transitionToRouteWithParams('pasokaras.index', {page: 1, order_by: "title_sort asc"})
