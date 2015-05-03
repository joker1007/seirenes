import React from 'react';
import _ from 'lodash';
import {Link} from 'react-router';
import {getRouteNameFromPath} from '../route';
import URI from 'URIjs';

export default class PasokaraTag extends React.Component {
  render() {
    let routeName = _.last(this.props.flux.router.getCurrentRoutes()).name;
    if (!routeName)
      return <span key={tag} />;
    let tag = this.props.tag;
    let q = this.props.flux.router.getCurrentQuery()["q"]
    let query = {
      q: q,
      filter_tags: this.props.filterTags.push(tag).toArray(),
    };
    return (
      <span key={tag} className="info-tag">
        <Link to={routeName} query={query}>{tag}</Link>
      </span>
    )
  }
}
