import React from 'react';
import PasokaraTag from './pasokara_tag.jsx';
import moment from 'moment';
import 'moment-duration-format';

export default class PasokaraListItem extends React.Component {
  render() {
    let pasokara = this.props.pasokara;
    let pasokaraTags = pasokara.tags.map(t => {
      return <PasokaraTag tag={t} />
    });
    let niconicoLink = `http://www.nicovideo.jp/watch/${pasokara.nico_vid}`;
    let duration = moment.duration(pasokara.duration, 'seconds').format("m:ss")
    let nicoPostedAt = moment(pasokara.nico_posted_at)
    return (
      <div className="pasokara">
        <div className="title">
          <a href={pasokara.url}>{pasokara.title}</a>
          <a className="btn btn-primary">予約する</a>
        </div>
        <div className="info-box">
          <div className="thumb">
            <img src={pasokara.thumbnail_url} width="160" height="120" />
          </div>
          <div className="inner-info-box">
            <div className="tag-box">
              <div className="info-type">タグ</div>
              <div className="tag-list">
                {pasokaraTags}
              </div>
            </div>
            <div className="meta-info-box">
              <div className="info-type">動画情報</div>
              <div className="info-list">
                <div className="info-entity">
                  <span className="info-key">再生時間:</span>
                  <span className="info-value">{duration}</span>
                </div>
                <div className="info-entity">
                  <span className="info-key">ニコニコID:</span>
                  <span className="info-value">
                    <a href={niconicoLink}>{pasokara.nico_vid}</a>
                  </span>
                </div>
                <div className="info-entity">
                  <span className="info-key">投稿日:</span>
                  <span className="info-value">{nicoPostedAt.format('YYYY/MM/DD HH:mm:ss')}</span>
                </div>
                <div className="info-entity">
                  <span className="info-key">再生数:</span>
                  <span className="info-value">{pasokara.nico_view_count}</span>
                </div>
                <div className="info-entity"><span className="info-key">マイリスト数:</span><span className="info-value">{pasokara.nico_mylist_count}</span>
                </div>
              </div>
            </div>
            <div className="add-favorite">
              <a href="#">お気に入りに追加する</a>
            </div>
          </div>
        </div>
      </div>
    );
  }
}
