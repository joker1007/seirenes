import React from 'react';
import FluxComponent from 'flummox/component';
import Player from '../components/player.jsx';
import SongQueueList from '../components/song_queue_list.jsx';

export default class PartyRoute extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      q: ""
    };
  }

  componentDidMount() {
    this._loadSongQueues();
  }

  componentWillReceiveProps(nextProps) {
    this._loadSongQueues();
  }

  componentWillUnmount() {
    clearTimeout(this.timer);
  }

  handleQueryChange(e) {
    this.setState({q: e.target.value});
  }

  render() {
    return (
      <div>
        <div id="query-layer">
          <input type="text" name="q" id="query_for_random" className="form-control" value={this.state.q} onChange={this.handleQueryChange.bind(this)} />
        </div>
        <div id="player-layer">
          <FluxComponent connectToStores={{
            current_playing: store => ({
              currentPlaying: store.getCurrentPlaying()
            })
          }}>
            <Player />
          </FluxComponent>
          <FluxComponent connectToStores={{
            song_queues: store => ({
              songQueues: store.getAll()
            })
          }}>
            <SongQueueList />
          </FluxComponent>
        </div>
      </div>
    );
  }

  _loadSongQueues() {
    this.timer = setTimeout(() => {
      this.props.flux.getActions('song_queues').loadWithRandom(this.state.q);
      this._loadSongQueues();
    }, 5000);
  }
}
