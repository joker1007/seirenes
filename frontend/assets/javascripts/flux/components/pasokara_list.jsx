import React from 'react';
import FluxComponent from 'flummox/component';
import _ from 'lodash';
import PasokaraListItem from './pasokara_list_item.jsx';

export default class PasokaraList extends React.Component {
  render() {
    let pasokaras;

    if (_.isEmpty(this.props.pasokaras)) {
      pasokaras = "";
    } else {
      pasokaras = _.map(this.props.pasokaras, p => {
        let key = `pasokara-${p.id}`;

        return (
          <FluxComponent key={key}>
            <PasokaraListItem pasokara={p} />
          </FluxComponent>
        );
      });
    }

    return (
      <div>
        {pasokaras}
      </div>
    );
  }
}
