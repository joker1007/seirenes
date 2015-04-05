import React from 'react';
import _ from 'lodash';
import PasokaraListItem from './pasokara_list_item.jsx';

export default class PasokaraList extends React.Component {
  render() {
    let pasokaras;

    if (_.isEmpty(this.props.pasokaras)) {
      pasokaras = <div />;
    } else {
      pasokaras = this.props.pasokaras.map(p => {
        return <PasokaraListItem key={p.id} pasokara={p}/>
      });
    }

    return (
      <div>
        {pasokaras}
      </div>
    );
  }
}
