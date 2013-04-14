class PlaylistsController < SongQueuesController
  def destroy
    @song_queue.finish!
    render json: {meta: {deleted: true}}
  end
end
