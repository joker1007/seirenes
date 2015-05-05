import React from 'react';
import FluxComponent from 'flummox/component';
import PlayerVideo from './player_video.jsx';

export default class Player extends React.Component {
  render() {
    let playerComponent = <div />;
    let currentPlaying = this.props.currentPlaying;

    if (currentPlaying && currentPlaying.movie_url) {
      playerComponent = (
        <div id="video-area">
          <div id="video-layer">
            <FluxComponent>
              <PlayerVideo currentPlaying={currentPlaying} />
            </FluxComponent>
          </div>
        </div>
      );
    }

    return playerComponent;
  }
}
