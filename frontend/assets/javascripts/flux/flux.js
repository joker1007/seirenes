import Flummox from 'flummox';
import Router from 'react-router';

import PasokaraActions from './actions/pasokara_actions';
import PasokaraStore from './stores/pasokara_store';

import FilterTagActions from './actions/filter_tag_actions';
import CurrentFilterTagsStore from './stores/current_filter_tags_store';

import EncodingStore from './stores/encoding_store';

import SongQueueActions from './actions/song_queue_actions';
import SongQueuesStore from './stores/song_queues_store';
import CurrentPlayingStore from './stores/current_playing_store';

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
    this.createStore('encodings', EncodingStore, this);
    this.createActions('song_queues', SongQueueActions);
    this.createStore('song_queues', SongQueuesStore, this);
    this.createStore('current_playing', CurrentPlayingStore, this);
  }
}
