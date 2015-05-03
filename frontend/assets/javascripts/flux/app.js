import React from 'react';
import Flux from './flux';
import FluxComponent from 'flummox/component';
import Router from 'react-router';
import PasokarasRoute from './routes/pasokaras_route.jsx';
import _ from 'lodash';

var flux = new Flux();

window.addEventListener("DOMContentLoaded", () => {
  flux.router.run((Handler, state) => {
    let loadPasokaras = _.some(state.routes, (r) => {
      return r.handler.loadPasokaras;
    });
    if (loadPasokaras) {
      flux.getActions('pasokaras').load(state.path);
    }
    flux.getActions('filter_tags').init(state.query.filter_tags);

    React.render(
      <FluxComponent flux={flux}>
        <Handler />
      </FluxComponent>,
      document.getElementById("app"));
  });
});

document.addEventListener("page:load", () => {
  flux.router.refresh();
});
