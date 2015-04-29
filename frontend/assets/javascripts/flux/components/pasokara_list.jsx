import React from 'react';
import _ from 'lodash';
import PasokaraListItem from './pasokara_list_item.jsx';

export default class PasokaraList extends React.Component {
  render() {
    let pasokaras;

    if (_.isEmpty(this.props.pasokaras)) {
      pasokaras = "";
    } else {
      pasokaras = _.map(this.props.pasokaras, p => {
        let key = `pasokara-${p.id}`
        return <PasokaraListItem key={key} pasokara={p}/>
      });
    }

    return (
      <div>
        {pasokaras}
      </div>
    );
  }
}
