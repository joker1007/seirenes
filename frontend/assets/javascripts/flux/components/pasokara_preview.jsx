import React from 'react';
import FluxComponent from 'flummox/component';
import PreviewPlayer from './preview_player.jsx';

export default class PasokaraPreview extends React.Component {
  render() {
    let pasokara = this.props.pasokara;
    let component = <div />;
    if (pasokara) {
      component = (
        <div>
          <h3 id="pasokara-preview-title">{pasokara.get("title")}</h3>
          <FluxComponent connectToStores={{
            encodings: store => ({
              encoding: store.find(pasokara.get("id"))
            })
          }}>
            <PreviewPlayer pasokara={pasokara} />
          </FluxComponent>
        </div>
      );
    }

    return component;
  }
}

PasokaraPreview.contextTypes = {
  router: React.PropTypes.func.isRequired
};
