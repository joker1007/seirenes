import React from 'react';
import _ from 'lodash';
import FluxComponent from 'flummox/component';
import PasokaraPreview from '../components/pasokara_preview.jsx';

export default class PasokaraShowRoute extends React.Component {
  componentDidMount() {
    let pasokaraId = _.parseInt(this.props.params.pasokaraId);
    let pasokara = this.props.flux.getStore('pasokaras').find(pasokaraId);
    if (!pasokara) {
      this.props.flux.getActions('pasokaras').loadSingle(pasokaraId);
    }
  }

  componentWillReceiveProps(nextProps) {
    let pasokaraId = _.parseInt(this.props.params.pasokaraId);
    let pasokara = this.props.flux.getStore('pasokaras').find(pasokaraId);
    if (!pasokara) {
      this.props.flux.getActions('pasokaras').loadSingle(pasokaraId);
    }
  }

  render() {
    let pasokaraId = _.parseInt(this.props.params.pasokaraId);
    return (
      <FluxComponent connectToStores={{
        pasokaras: store => ({
          pasokara: store.find(pasokaraId)
        })
      }}>
        <PasokaraPreview />
      </FluxComponent>
    );
  }
}
