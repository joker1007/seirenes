import React from 'react';
import _ from 'lodash';
import {Link} from 'react-router';
import URI from 'URIjs';

export default class PasokaraTag extends React.Component {
  render() {
    let routeName = this.context.routeName;
    let tag = this.props.tag;
    if (!routeName) {
      return <span key={tag} />;
    }
    let q = this.context.router.getCurrentQuery().q;
    let query = {
      q: q,
      filter_tags: this.props.filterTags.add(tag).toArray()
    };

    return (
      <span key={tag} className="info-tag">
        <Link to={routeName} query={query}>{tag}</Link>
      </span>
    );
  }
}

PasokaraTag.propTypes = {
  tag: React.PropTypes.string.isRequired
}

PasokaraTag.contextTypes = {
  router: React.PropTypes.func.isRequired,
  routeName: React.PropTypes.string.isRequired
};
