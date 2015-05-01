import React from 'react';
import FluxComponent from 'flummox/component';
import Pagination from '../components/pagination.jsx';
import PasokaraList from '../components/pasokara_list.jsx';
import SortForm from '../components/sort_form.jsx';
import FacetTags from '../components/facet_tags.jsx';

export default class PasokarasRoute extends React.Component {
  render() {
    return(
      <div>
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

PasokarasRoute.loadPasokaras = true;
