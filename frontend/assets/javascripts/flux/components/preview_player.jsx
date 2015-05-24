import React from 'react';
import MyRecorder from '../lib/recorder.coffee';

export default class PreviewPlayer extends React.Component {
  constructor(props) {
    super(props);
    this.state = {recordedData: null, recordedUrl: null, recording: false};
  }

  startRecording() {
    let video = React.findDOMNode(this.refs.previewPlayer);
    this.recorder = new MyRecorder({
      video: video,
      started: () => {
        this.setState({recording: true});
      }
    });
  }

  stopRecording() {
    this.recorder.stopRecord((blob) => {
      this.setState({recordedData: blob, recordedUrl: URL.createObjectURL(blob), recording: false});
    });
  }

  render() {
    let pasokara = this.props.pasokara;
    let encoding = this.props.encoding;
    let encodingProgress = encoding ? encoding.progress : 0;
    let previewPlayer;
    let recordButton;
    let recorded = <div id="recorded" />;

    if (this.state.recording) {
      recordButton = <button onClick={this.stopRecording.bind(this)}>Stop Rec</button>;
    } else {
      recordButton = <button onClick={this.startRecording.bind(this)}>Start Rec</button>;
    }

    if (this.state.recordedData) {
      recorded = (
        <div id="recorded">
          <audio src={this.state.recordedUrl} controls></audio>
        </div>
      );
    }

    if (pasokara.get("movie_url")) {
      previewPlayer = (
        <div id="pasokara-movie-area">
          <div id="pasokara-preview">
            <video id="preview-player" className="preview" ref="previewPlayer" controls>
              <source type="video/mp4" src={pasokara.get("movie_url")}></source>
            </video>
          </div>
          <div id="record-control">
            {recordButton}
            {recorded}
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
        if (!encoding) {
          this.props.flux.getActions('pasokaras').encode(pasokara.get("id"));
        }
      }, 1);
    }

    return (
      <div id="pasokara-preview-player">
        {previewPlayer}
      </div>
    );
  }
}
