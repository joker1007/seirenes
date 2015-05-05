import React from 'react';
import _ from 'lodash';

export default class SongQueueList extends React.Component {
  render() {
    let songQueues = this.props.songQueues;
    let songQueueItems;

    if (_.isEmpty(songQueues)) {
      songQueueItems = (
        <div className="song_queue" style={{marginTop: "40px"}}>
          <span className="title">予約がありません</span>
        </div>
      );
    } else {
      songQueueItems = songQueues.map((s) => {
        let title = s.movie_url ? s.title : `${s.title} (encoding...)`
        return (
          <div key={`song_queue-${s.id}`} className="song_queue">
            <img className="thumb" src={s.thumbnail_url} width="160" height="120" />
            <span className="title">{title}</span>
          </div>
        );
      });
    }

    return (
      <div id="#song_queue-list">
        {songQueueItems}
      </div>
    );
  }
}
