import React from 'react';
import FluxComponent from 'flummox/component';
import Player from '../components/player.jsx';
import SongQueueList from '../components/song_queue_list.jsx';

export default class PlayerRoute extends React.Component {
  componentDidMount() {
    this._loadSongQueues();
  }

  componentWillReceiveProps(nextProps) {
    this._loadSongQueues();
  }

  componentWillUnmount() {
    clearTimeout(this.timer);
  }

  render() {
    return (
      <div>
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
      this.props.flux.getActions('song_queues').load();
      this._loadSongQueues();
    }, 5000);
  }
}
