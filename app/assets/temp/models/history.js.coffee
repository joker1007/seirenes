Seirenes.History = DS.Model.extend
  title: DS.attr('string')
  pasokara: DS.belongsTo('Seirenes.Pasokara')
  pasokaraUrl: DS.attr('string')
  thumbnailUrl: DS.attr('string')
  movieUrl: DS.attr('string')