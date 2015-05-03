import React from 'react';
import FluxComponent from 'flummox/component';
import Pagination from '../components/pagination.jsx';
import PasokaraList from '../components/pasokara_list.jsx';
import SortForm from '../components/sort_form.jsx';
import FacetTags from '../components/facet_tags.jsx';
import SearchField from '../components/search_field.jsx';

export default class PasokarasRoute extends React.Component {
  componentDidMount() {
    this.props.flux.getActions('pasokaras').load(this.context.router.getCurrentPath());
    this.props.flux.getActions('filter_tags').init(this.props.query.filter_tags);
  }
  componentWillReceiveProps(nextProps) {
    this.props.flux.getActions('pasokaras').load(this.context.router.getCurrentPath());
    this.props.flux.getActions('filter_tags').init(this.props.query.filter_tags);
  }

  render() {
    return(
      <div>
        <FluxComponent>
          <SearchField />
        </FluxComponent>
        <FluxComponent connectToStores={{
          pasokaras: store => ({
            facets: store.getFacets(),
          }),
          filter_tags: store => ({
            filterTags: store.getTags(),
          }),
        }}>
          <FacetTags />
        </FluxComponent>
        <SortForm />
        <FluxComponent connectToStores={{
          pasokaras: store => ({
            meta: store.getMeta(),
          })
        }}>
          <Pagination />
        </FluxComponent>
        <div id="pasokara-list">
          <FluxComponent connectToStores={{
            pasokaras: store => ({
              pasokaras: store.getAll(),
            })
          }}>
            <PasokaraList />
        </FluxComponent>
        </div>
        <FluxComponent connectToStores={{
          pasokaras: store => ({
            meta: store.getMeta(),
          })
        }}>
          <Pagination />
        </FluxComponent>
      </div>
    );
  }
}

PasokarasRoute.contextTypes = {
  router: React.PropTypes.func.isRequired
};
