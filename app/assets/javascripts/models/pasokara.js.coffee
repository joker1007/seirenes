Seirenes.Pasokara = DS.Model.extend
  title: DS.attr("string")
  nico_vid: DS.attr("string")
  nico_posted_at: DS.attr("date")
  nico_description: DS.attr("string")
  nico_view_count: DS.attr("number")
  nico_mylist_count: DS.attr("number")
  duration: DS.attr("number")
  url: DS.attr("string")
  thumbnailUrl: DS.attr("string")
  tags: DS.hasMany('Seirenes.Tag')

