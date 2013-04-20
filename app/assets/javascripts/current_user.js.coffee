if current_user_info = $("meta[current_user]").attr("current_user")
  data = JSON.parse(current_user_info)
  Seirenes.current_user = Ember.Object.create(data.user)
else
  Seirenes.current_user = null
