Seirenes.Recording = DS.Model.extend
  publicFlag: DS.attr("boolean")
  dataUrl: DS.attr("string")
  pasokara: DS.belongsTo('Seirenes.Pasokara')
  title: DS.attr("string")
  userName: DS.attr("string")
  createdAt: DS.attr("date")

  formattedCreatedAt: (->
    d = @get("createdAt")
    year = d.getFullYear()
    month = d.getMonth() + 1
    day = d.getDate()
    hour = d.getHours()
    minute = d.getMinutes()

    month = if month < 10 then "0#{month}" else "#{month}"
    day = if day < 10 then "0#{day}" else "#{day}"
    hour = if hour < 10 then "0#{hour}" else "#{hour}"
    minute = if minute < 10 then "0#{minute}" else "#{minute}"
    "#{year}/#{month}/#{day} #{hour}:#{minute}"
  ).property("createdAt")
