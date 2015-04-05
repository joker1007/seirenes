import Flummox from 'flummox';

import PasokaraActions from './actions/pasokara_actions';
import PasokaraStore from './stores/pasokara_store';

export default class SeirenesApp extends Flummox {
  constructor() {
    super();
    this.createActions('pasokaras', PasokaraActions);
    this.createStore('pasokaras', PasokaraStore, this);
  }
}
