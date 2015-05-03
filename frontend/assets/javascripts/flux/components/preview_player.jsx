import React from 'react';

export default class PreviewPlayer extends React.Component {
  render() {
    let pasokara = this.props.pasokara;
    let encoding = this.props.encoding;
    let encodingProgress = encoding ? encoding.progress : 0;

    let previewPlayer;
    if (pasokara.movie_url) {
      previewPlayer = (
        <div id="pasokara-movie-area">
          <div id="pasokara-preview">
            <video id="preview-player" className="preview" controls>
              <source type="video/mp4" src={pasokara.movie_url}></source>
            </video>
          </div>
          <div id="record-control">
            <button>Start Rec</button>
            <button>Stop Rec</button>
            <div id="recorded">
              <audio src={pasokara.recordedUrl} controls></audio>
            </div>
          </div>
        </div>
      );
    } else {
      previewPlayer = (
        <div id="pasokara-movie-area">
          <div id="pasokara-preview">
            <div className="progress">
              <div className="progress-bar" role="progressbar" aria-valuenow={encodingProgress} aria-valuemin="0" aria-valuemax="100" style={{width: `${encodingProgress}%`}}>
                {encodingProgress}%
              </div>
            </div>
          </div>
        </div>
      );

      // 何故かこうしないと動かない
      setTimeout(() => {
        if (!encoding)
          this.props.flux.getActions('pasokaras').encode(pasokara.id);
      }, 1);
    }

    return (
      <div id="pasokara-preview-player">
        {previewPlayer}
      </div>
    );
  }
}
