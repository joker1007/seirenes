import React from 'react';
import {Link} from 'react-router';
import {getRouteNameFromPath} from '../route';

export default class CurrentFilterTags extends React.Component {
  render() {
    let current = this.props.filterTags.toArray().map((t) => {
      return <FilterTag key={"filter-tag-" + t} tag={t} flux={this.props.flux} filterTags={this.props.filterTags} />
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
    let routeName = getRouteNameFromPath(this.props.flux.router.getCurrentPathname());
    let idx = this.props.filterTags.indexOf(this.props.tag);
    let q = this.props.flux.router.getCurrentQuery()["q"];
    let query = {
      q: q,
      filter_tags: this.props.filterTags.remove(idx).toArray(),
    };
    return(
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
