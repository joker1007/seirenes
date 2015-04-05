import { Store } from 'flummox';

export default class PasokaraStore extends Store {
  constructor(flux) {
    super();
    const pasokaraActionIds = flux.getActionIds('pasokaras');
    this.register(pasokaraActionIds.init, this.handleInit);
    this.register(pasokaraActionIds.load, this.handleInit);

    this.state = {
      pasokaras: [],
      meta: {},
    }
  }

  getAll() {
    return this.state.pasokaras;
  }

  getMeta() {
    return this.state.meta;
  }

  handleInit({pasokaras: pasokaras, meta: meta}) {
    this.setState({
      pasokaras: pasokaras,
      meta: meta,
    });
  }
}
