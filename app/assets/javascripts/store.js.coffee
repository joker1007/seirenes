DS.RESTAdapter.configure "plurals", {
  history: "histories"
}

Seirenes.Store = DS.Store.extend
  revision: 13
  adapter: DS.RESTAdapter.create({
    didFindQuery: (store, type, payload, recordArray) ->
      loader = DS.loaderFor(store)

      loader.populateArray =  (data) ->
        recordArray.load(data)
        recordArray.set('meta', payload.meta)

      Ember.get(this, 'serializer').extractMany(loader, payload, type)
  })

