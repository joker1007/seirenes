json.extract! recorded_song, :id, :public_flag, :user_id, :pasokara_id, :created_at
json.user_name recorded_song.user.screen_name
json.title recorded_song.pasokara.title
json.data_url recorded_song.data.url
