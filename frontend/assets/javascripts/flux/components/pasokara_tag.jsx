import React from 'react';
import URI from 'URIjs';

export default class PasokaraTag extends React.Component {
  render() {
    let tag = this.props.tag;
    // TODO: 現在の検索クエリ状態を設定できるようにする
    let uri = new URI('/pasokaras');
    uri.search({"filter_tags[]": tag})
    let href = uri.toString();
    return (
      <span className="info-tag">
        <a href={href}>{tag}</a>
      </span>
    )
  }
}
