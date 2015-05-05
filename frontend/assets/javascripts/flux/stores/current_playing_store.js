import { Store } from 'flummox';

export default class CurrentPlayingStore extends Store {
  constructor(flux) {
    super();
    this.flux = flux;

    const actionIds = flux.getActionIds('song_queues');
    this.register(actionIds.load, this.handleSongQueueLoad);
    this.register(actionIds.finish, this.handleSongQueueFinish);

    this.state = {
      data: null,
      playing: false,
    };
  }

  getCurrentPlaying() {
    return this.state.data;
  }

  handleSongQueueLoad() {
    let songQueuesStore = this.flux.getStore('song_queues');
    this.flux.waitFor(songQueuesStore);

    let firstQueue = songQueuesStore.getFirst()
    if (!this.state.playing && firstQueue && firstQueue.movie_url) {
      this.setState({
        data: firstQueue,
        playing: true
      })
    }
  }

  handleSongQueueFinish() {
    this.setState({
      data: null,
      playing: false,
    });
  }
}
