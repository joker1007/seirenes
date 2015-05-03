import React from 'react';
import FluxComponent from 'flummox/component';
import {Link} from 'react-router';
import _ from 'lodash';
import {getRouteNameFromPath} from '../route';
import CurrentFilterTags from './current_filter_tags.jsx';

export default class FacetTags extends React.Component {
  render() {
    let routeName = getRouteNameFromPath(this.props.flux.router.getCurrentPathname());
    let facets = this.props.facets
    let tags = []
    let q = this.props.flux.router.getCurrentQuery()["q"]

    for (let name in facets) {
      let text = `${name}(${facets[name]})`
      let query = {
        q: q,
        filter_tags: this.props.filterTags.push(name).toArray(),
      };
      tags.push(
        <span key={name} className="facet-tag">
          <Link to={routeName} query={query}>{text}</Link>
        </span>
      );
    }

    let facetTagList = null;
    if (_.isEmpty(facets)) {
      facetTagList = <div />
    } else {
      facetTagList = (
        <div>
          <div id="facet-tags">
            <h4>
              <span className="glyphicon glyphicon-tags"></span>
              タグ一覧
            </h4>
            <div id="facet-tags-list">
              {tags}
            </div>
          </div>
          <FluxComponent connectToStores={{
            filter_tags: store => ({
              filterTags: store.getTags(),
            }),
          }}>
            <CurrentFilterTags />
          </FluxComponent>
        </div>
      );
    }

    return facetTagList;
  }
}
