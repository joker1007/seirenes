import { Store } from 'flummox';

export default class EncodingStore extends Store {
  constructor(flux) {
    super();
    const pasokaraActionIds = flux.getActionIds('pasokaras');
    this.register(pasokaraActionIds.encode, this.handleEncode);
    this.register(pasokaraActionIds.updateProgress, this.handleUpdateProgress);

    this.state = {
      encodings: {},
    }
  }

  find(id) {
    return this.state.encodings[id];
  }

  handleEncode(id) {
    if (id) {
      let _encodings = Object.assign({}, this.state.encodings);
      _encodings[id] = {progress: 0};
      this.setState({encodings: _encodings});
    }
  }

  handleUpdateProgress({id, progress}) {
    let _encodings = Object.assign({}, this.state.encodings);
    _encodings[id] = {progress: progress};
    this.setState({encodings: _encodings});
  }
}
