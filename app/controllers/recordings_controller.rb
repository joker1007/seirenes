class RecordingsController < ApplicationController
  before_action :authenticate, only: [:create, :destroy]
  before_action :set_recorded_song, only: [:show, :destroy]

  def index
    if request.xhr?
      @recorded_songs = RecordedSong.order("created_at DESC")
    end
  end

  def show
  end

  def create
    if content_length = parse_content_length
      chunk_create(content_length)
    else
      render json: {errors: {base: "File size is too small"}}, status: :unprocessable_entity
    end
  end

  def destroy
    @recorded_song.destroy
    render json: {}, status: :ok
  end

  private
  def set_recorded_song
    @recorded_song = RecordedSong.find(params[:id])
  end

  def create_recorded_song
    Resque.enqueue(RecordedSongEncodeJob, temp_chunked_filename.to_s, current_user.id, params[:pasokara_id])
    render json: {upload: "ok"}
  end

  def temp_chunked_filename
    Rails.root + "tmp" + "#{current_user.id}-#{params[:pasokara_id]}.wav"
  end

  def parse_content_length
    if content_length = request.env["HTTP_CONTENT_RANGE"]
      content_length =~ /bytes (\d+)-(\d+)\/(\d+)/
      {from: $1.to_i, to: $2.to_i, total: $3.to_i}
    else
      nil
    end
  end

  def chunk_create(content_length)
    if content_length[:to] + 1 == content_length[:total]
      last_chunk_process
    elsif content_length[:from] == 0
      initial_chunk_process
    else
      chunk_process
    end
  end

  def initial_chunk_process
    File.open(temp_chunked_filename, "wb") {|f| f.write(params[:files].first.read)}
    render json: {chunk: "ok"}
  end

  def chunk_process
    File.open(temp_chunked_filename, "ab") {|f| f.write(params[:files].first.read)}
    render json: {chunk: "ok"}
  end

  def last_chunk_process
    File.open(temp_chunked_filename, "ab") {|f| f.write(params[:files].first.read)}
    create_recorded_song
  end
end
