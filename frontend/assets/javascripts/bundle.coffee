# require _request_animation_frame
# require jquery
# require jquery_ujs
# require spin.js
# require jquery.spin
# require jquery.lazyload
# require turbolinks
# require jquery.turbolinks
# require nprogress
# require nprogress-turbolinks
# require bootstrap
# require lodash
# require backbone
# require backbone.stickit/backbone.stickit
# require backbone.babysitter
# require backbone.wreqr
# require backbone.marionette
# require gritter
# require gritter_image
# require get_user_media_wrap
# require add_song_queue_notification
# require recorder
# require jquery.ui.widget
# require jquery.fileupload
# require_self
# require_tree .

window.jQuery = require('jquery')
window.$ = jQuery
require('jquery-ujs')
require('jquery_lazyload/jquery.lazyload')

window.Seirenes = require('./backbone/app')
require('./backbone/controllers/player_controller')
require('./backbone/controllers/pasokara_show_controller')

requestAnimationFrameWrap = require('./request_animation_frame_wrap')
window.requestAnimationFrame = requestAnimationFrameWrap.requestAnimationFrame
window.cancelAnimationFrame = requestAnimationFrameWrap.cancelAnimationFrame

navigator.getUserMedia = require('./get_user_media_wrap')

toastr = require('toastr')
toastr.options.closeButton = true

$(document).on "ajax:success", ".js-add_queue", (e, data) ->
  toastr.success("「#{data.pasokara.title}」を予約に追加しました")

$(document).on "ajax:success", ".js-add_favorite", (e, data) ->
  toastr.success("「#{data.pasokara.title}」をお気に入りに追加しました")

$(document).on "ajax:error", ".js-add_favorite", (e) ->
  toastr.error("既に登録済みです")

$(document).on "ajax:success", ".js-remove_favorite", (e, data) ->
  toastr.success("「#{data.pasokara.title}」をお気に入りから削除しました")

$(document).on "ajax:error", ".js-remove_favorite", (e, data) ->
  toastr.success("既に削除済みです")
