import { Store } from 'flummox';

export default class SongQueuesStore extends Store {
  constructor(flux) {
    super();

    const actionIds = flux.getActionIds('song_queues');
    this.register(actionIds.load, this.handleLoad);

    this.state = {
      pasokaras: [],
    }
  }

  getAll() {
    return this.state.pasokaras;
  }

  getFirst() {
    return this.state.pasokaras[0];
  }

  handleLoad(songQueues) {
    this.setState({pasokaras: songQueues});
  }
}
