import { Store } from 'flummox';
import _ from 'lodash';

export default class PasokaraStore extends Store {
  constructor(flux) {
    super();
    const pasokaraActionIds = flux.getActionIds('pasokaras');
    this.register(pasokaraActionIds.load, this.handleInit);

    this.state = {
      pasokaras: {},
      facets: {},
      meta: {},
    }
  }

  getAll() {
    return this.state.pasokaras;
  }

  getMeta() {
    return this.state.meta;
  }

  getFacets() {
    return this.state.facets;
  }

  handleInit({pasokaras, meta, facets}) {
    let _pasokaras = {};
    let _facets = {};

    pasokaras.forEach((p) => {
      _pasokaras[p.id] = p;
    });

    facets.forEach((f) => {
      _facets[f.name] = f.count;
    });

    this.setState({
      pasokaras: _pasokaras,
      meta: meta,
      facets: _facets,
    });
  }
}
