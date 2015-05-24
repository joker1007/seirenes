import { Store } from 'flummox';
import Immutable from 'immutable';
var List = Immutable.List;

export default class SongQueuesStore extends Store {
  constructor(flux) {
    super();

    const actionIds = flux.getActionIds('song_queues');
    this.register(actionIds.load, this.handleLoad);
    this.register(actionIds.finish, this.handleFinish);

    this.state = {
      pasokaras: List()
    };
  }

  getAll() {
    return this.state.pasokaras.toArray();
  }

  getFirst() {
    return this.state.pasokaras.first();
  }

  handleLoad(songQueues) {
    this.setState({pasokaras: List(songQueues)});
  }

  handleFinish() {
    this.setState({pasokaras: this.state.pasokaras.rest()});
  }
}
