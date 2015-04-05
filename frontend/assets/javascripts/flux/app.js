import React from 'react';
import Flux from './flux';
import FluxComponent from 'flummox/component';
import PasokaraList from './components/pasokara_list.jsx';

var flux = new Flux();

window.addEventListener("DOMContentLoaded", () => {
  flux.getActions('pasokaras').load('/pasokaras.json');
  React.render(
    <FluxComponent flux={flux} connectToStores={{
      pasokaras: store => ({
        pasokaras: store.getAll(),
      })
    }}>
      <PasokaraList />
    </FluxComponent>,
    document.getElementById("pasokara-list")
  );
});
