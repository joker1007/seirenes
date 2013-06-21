Seirenes.Recording = DS.Model.extend
  publicFlag: DS.attr("boolean")
  dataUrl: DS.attr("string")
  pasokara: DS.belongsTo('Seirenes.Pasokara')
  title: DS.attr("string")
  userName: DS.attr("string")
  createdAt: DS.attr("date")

