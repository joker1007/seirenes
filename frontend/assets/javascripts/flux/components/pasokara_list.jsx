import React from 'react';
import FluxComponent from 'flummox/component';
import _ from 'lodash';
import PasokaraListItem from './pasokara_list_item.jsx';

export default class PasokaraList extends React.Component {
  render() {
    let pasokaras;

    if (this.props.pasokaras.isEmpty()) {
      pasokaras = "";
    } else {
      pasokaras = this.props.pasokaras.reduce((r, p, id) => {
        let key = `pasokara-${id}`;

        r.push(
          <FluxComponent key={key}>
            <PasokaraListItem pasokara={p} />
          </FluxComponent>
        );
        return r;
      }, []);
    }

    return (
      <div>
        {pasokaras}
      </div>
    );
  }
}
