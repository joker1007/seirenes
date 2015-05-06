import { Store } from 'flummox';
import _ from 'lodash';

export default class PasokaraStore extends Store {
  constructor(flux) {
    super();
    const pasokaraActionIds = flux.getActionIds('pasokaras');
    this.register(pasokaraActionIds.load, this.handleLoad);
    this.register(pasokaraActionIds.loadSingle, this.handleLoadSingle);
    this.register(pasokaraActionIds.updateMovieUrl, this.handleUpdateMovieUrl);
    this.register(pasokaraActionIds.addToFavorite, this.handleFavorite);
    this.register(pasokaraActionIds.removeFromFavorite, this.handleUnFavorite);

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

  find(id) {
    return this.state.pasokaras[id];
  }

  handleLoad({pasokaras, meta, facets}) {
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

  handleLoadSingle(pasokara) {
    if (pasokara && !this.state.pasokaras[pasokara.id]) {
      let _pasokaras = Object.assign({}, this.state.pasokaras);
      _pasokaras[pasokara.id] = pasokara;
      this.setState({pasokaras: _pasokaras});
    }
  }

  handleUpdateMovieUrl({id, movie_url}) {
    let pasokara = this.state.pasokaras[id];
    pasokara.movie_url = movie_url;
    let _pasokaras = Object.assign({}, this.state.pasokaras);
    _pasokaras[id] = pasokara
    this.setState({pasokaras: _pasokaras});
  }

  handleFavorite({pasokara_id: id}) {
    let _pasokaras = Object.assign({}, this.state.pasokaras);
    let pasokara = this.state.pasokaras[id];
    let newPasokara = Object.assign({}, pasokara, {favorited: true});
    _pasokaras[id] = newPasokara
    this.setState({pasokaras: _pasokaras});
  }

  handleUnFavorite({pasokara_id: id}) {
    let _pasokaras = Object.assign({}, this.state.pasokaras);
    let pasokara = this.state.pasokaras[id];
    let newPasokara = Object.assign({}, pasokara, {favorited: false});
    _pasokaras[id] = newPasokara
    this.setState({pasokaras: _pasokaras});
  }
}
