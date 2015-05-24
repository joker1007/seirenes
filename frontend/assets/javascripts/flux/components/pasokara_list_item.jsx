import React from 'react';
import {Link} from 'react-router';
import FluxComponent from 'flummox/component';
import PasokaraTag from './pasokara_tag.jsx';
import moment from 'moment';
import 'moment-duration-format';

export default class PasokaraListItem extends React.Component {
  enqueue() {
    let pasokara = this.props.pasokara;
    let msg = `「${pasokara.get("title")}」を予約しますか？`;
    if (window.confirm(msg)) {
      this.props.flux.getActions('pasokaras').enqueue(pasokara.get("id"));
    }
  }

  addToFavorite() {
    let pasokara = this.props.pasokara;
    this.props.flux.getActions('pasokaras').addToFavorite(pasokara.get("id"));
  }

  removeFromFavorite() {
    let pasokara = this.props.pasokara;
    this.props.flux.getActions('pasokaras').removeFromFavorite(pasokara.get("id"));
  }

  render() {
    let pasokara = this.props.pasokara;
    let pasokaraTags = pasokara.get("tags").reduce((r, t) => {
      r.push(
        <FluxComponent key={t} connectToStores={{
          filter_tags: store => ({
            filterTags: store.getTags()
          })
        }}>
          <PasokaraTag tag={t} />
        </FluxComponent>
      );
      return r;
    }, []);
    let niconicoLink = `http://www.nicovideo.jp/watch/${pasokara.get("nico_vid")}`;
    let duration = moment.duration(pasokara.get("duration"), 'seconds').format("m:ss");
    let nicoPostedAt = moment(pasokara.get("nico_posted_at"));

    let favoriteLink;
    if (pasokara.get("favorited")) {
      favoriteLink = <a className="btn btn-danger" onClick={this.removeFromFavorite.bind(this)}>お気に入りを削除する</a>;
    } else {
      favoriteLink = <a className="btn btn-primary" onClick={this.addToFavorite.bind(this)}>お気に入りに追加する</a>;
    }

    return (
      <div className="pasokara">
        <div className="title">
          <Link to="pasokara_show" params={{pasokaraId: pasokara.get("id")}}>{pasokara.get("title")}</Link>
          <a className="btn btn-primary" onClick={this.enqueue.bind(this)}>予約する</a>
        </div>
        <div className="info-box">
          <div className="thumb">
            <img src={pasokara.get("thumbnail_url")} width="160" height="120" />
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
                    <a href={niconicoLink}>{pasokara.get("nico_vid")}</a>
                  </span>
                </div>
                <div className="info-entity">
                  <span className="info-key">投稿日:</span>
                  <span className="info-value">{nicoPostedAt.format('YYYY/MM/DD HH:mm:ss')}</span>
                </div>
                <div className="info-entity">
                  <span className="info-key">再生数:</span>
                  <span className="info-value">{pasokara.get("nico_view_count")}</span>
                </div>
                <div className="info-entity"><span className="info-key">マイリスト数:</span><span className="info-value">{pasokara.get("nico_mylist_count")}</span>
                </div>
              </div>
            </div>
            <div className="add-favorite">
              {favoriteLink}
            </div>
          </div>
        </div>
      </div>
    );
  }
}

PasokaraListItem.propTypes = {
  pasokara: React.PropTypes.object.isRequired
};
