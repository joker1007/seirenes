import React from 'react';

export default class PlayerVideo extends React.Component {
  componentDidMount() {
    let video = React.findDOMNode(this.refs.player);
    video.addEventListener('ended', () => {
      this.handlePlayEnd();
    });
  }

  handlePlayEnd() {
    this.props.flux.getActions('song_queues').finish(this.props.currentPlaying.id);
  }

  render() {
    let playerComponent = <div />;
    let currentPlaying = this.props.currentPlaying;

    return (
      <video ref="player" className="fullscreen" width="640" height="480" controls autoPlay>
        <source type="video/mp4" src={currentPlaying.movie_url}></source>
      </video>
    );
  }
}
