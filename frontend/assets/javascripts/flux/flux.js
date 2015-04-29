import Flummox from 'flummox';
import Router from 'react-router';

import PasokaraActions from './actions/pasokara_actions';
import PasokaraStore from './stores/pasokara_store';

import {routes} from './route';

export default class SeirenesApp extends Flummox {
  constructor() {
    super();
    this.router = Router.create({
      routes: routes,
      location: Router.HistoryLocation,
    });
    this.createActions('pasokaras', PasokaraActions, this.router);
    this.createStore('pasokaras', PasokaraStore, this);
  }
}
