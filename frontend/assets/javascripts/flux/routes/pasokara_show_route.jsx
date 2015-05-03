import React from 'react';
import FluxComponent from 'flummox/component';
import PasokaraPreview from '../components/pasokara_preview.jsx';

export default class PasokaraShowRoute extends React.Component {
  componentDidMount() {
    let pasokaraId = this.props.params.pasokaraId;
    let pasokara = this.props.flux.getStore('pasokaras').find(pasokaraId);
    if (!pasokara)
      this.props.flux.getActions('pasokaras').loadSingle(pasokaraId);
  }

  componentWillReceiveProps(nextProps) {
    let pasokaraId = this.props.params.pasokaraId;
    let pasokara = this.props.flux.getStore('pasokaras').find(pasokaraId);
    if (!pasokara)
      this.props.flux.getActions('pasokaras').loadSingle(pasokaraId);
  }

  render() {
    return (
      <FluxComponent connectToStores={{
        pasokaras: store => ({
          pasokara: store.find(this.props.params.pasokaraId),
        })
      }}>
        <PasokaraPreview />
      </FluxComponent>
    );
  }
}
