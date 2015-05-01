import Flummox from 'flummox';
import Router from 'react-router';

import PasokaraActions from './actions/pasokara_actions';
import PasokaraStore from './stores/pasokara_store';

import FilterTagActions from './actions/filter_tag_actions';
import CurrentFilterTagsStore from './stores/current_filter_tags_store';

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
    this.createActions('filter_tags', FilterTagActions);
    this.createStore('filter_tags', CurrentFilterTagsStore, this);
  }
}
