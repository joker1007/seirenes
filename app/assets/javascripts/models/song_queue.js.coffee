Seirenes.SongQueue = DS.Model.extend
  title: DS.attr('string')
  url: DS.attr('string')
  pasokara: DS.belongsTo('Seirenes.Pasokara')
  pasokaraUrl: DS.attr('string')
  thumbnailUrl: DS.attr('string')
