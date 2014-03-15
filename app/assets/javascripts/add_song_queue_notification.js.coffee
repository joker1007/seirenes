$(document).on "ajax:success", ".js-add_queue", (e, data) ->
  $.gritter.add
    image: "#{gritter_success_image_path}"
    title: 'Success'
    text: "「#{data.pasokara.title}」を予約に追加しました"

$(document).on "ajax:success", ".js-add_favorite", (e, data) ->
  $.gritter.add
    image: "#{gritter_success_image_path}"
    title: 'Success'
    text: "「#{data.pasokara.title}」をお気に入りに追加しました"

$(document).on "ajax:error", ".js-add_favorite", (e) ->
  $.gritter.add
    image: "#{gritter_error_image_path}"
    title: 'Error'
    text: "既に登録済みです"

$(document).on "ajax:success", ".js-remove_favorite", (e, data) ->
  $.gritter.add
    image: "#{gritter_success_image_path}"
    title: 'Success'
    text: "「#{data.pasokara.title}」をお気に入りから削除しました"

$(document).on "ajax:error", ".js-remove_favorite", (e, data) ->
  $.gritter.add
    image: "#{gritter_error_image_path}"
    title: 'Success'
    text: "既に削除済みです"
