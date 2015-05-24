import { Store } from 'flummox';
import _ from 'lodash';
import Immutable from 'immutable';

var OrderedMap = Immutable.OrderedMap;

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
      pasokaras: OrderedMap(),
      facets: {},
      meta: {}
    };
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
    return this.state.pasokaras.get(_.parseInt(id));
  }

  handleLoad({pasokaras, meta, facets}) {
    let _pasokaras = _.reduce(pasokaras, (map, p) => {
      let _p = Immutable.fromJS(p, (k, v) => (v.toOrderedMap()));
      return map.set(p.id, _p);
    }, OrderedMap());
    let _facets = {};

    facets.forEach((f) => {
      _facets[f.name] = f.count;
    });

    this.setState({
      pasokaras: _pasokaras,
      meta: meta,
      facets: _facets
    });
  }

  handleLoadSingle(pasokara) {
    if (pasokara && !this.state.pasokaras.has(pasokara.id)) {
      let _pasokara = Immutable.fromJS(pasokara, (k, v) => (v.toOrderedMap()));
      let _pasokaras = this.state.pasokaras.set(pasokara.id, _pasokara);
      this.setState({pasokaras: _pasokaras});
    }
  }

  handleUpdateMovieUrl({id, movie_url}) {
    let pasokara = this.state.pasokaras.get(id).set("movie_url", movie_url);
    let _pasokaras = this.state.pasokaras.set(id, pasokara);
    this.setState({pasokaras: _pasokaras});
  }

  handleFavorite({pasokara_id: id}) {
    let pasokara = this.state.pasokaras.get(id).set("favorited", true);
    let _pasokaras = this.state.pasokaras.set(id, pasokara);
    this.setState({pasokaras: _pasokaras});
  }

  handleUnFavorite({pasokara_id: id}) {
    let pasokara = this.state.pasokaras.get(id).set("favorited", false);
    let _pasokaras = this.state.pasokaras.set(id, pasokara);
    this.setState({pasokaras: _pasokaras});
  }
}
