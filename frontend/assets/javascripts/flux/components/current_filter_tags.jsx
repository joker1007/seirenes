import React from 'react';
import _ from 'lodash';
import {Link} from 'react-router';

export default class CurrentFilterTags extends React.Component {
  render() {
    let current = this.props.filterTags.toArray().map((t) => {
      return <FilterTag key={"filter-tag-" + t} tag={t} flux={this.props.flux} filterTags={this.props.filterTags} />;
    });

    return (
      <div id="current-filter-tags">
        {current}
      </div>
    );
  }
}

class FilterTag extends React.Component {
  render() {
    let routeName = this.context.routeName;
    let q = this.props.flux.router.getCurrentQuery().q;
    let query = {
      q: q,
      filter_tags: this.props.filterTags.remove(this.props.tag).toArray()
    };
    return (
      <span key={"remove-" + this.props.tag} className="current-tag">
        &gt;
        {this.props.tag}
        &nbsp;
        <Link className="btn btn-xs btn-danger" to={routeName} query={query}>
          <span className="glyphicon glyphicon-remove" />
        </Link>
        &nbsp;
      </span>
    );
  }
}

FilterTag.propTypes = {
  tag: React.PropTypes.string.isRequired
};

FilterTag.contextTypes = {
  routeName: React.PropTypes.string.isRequired
};
