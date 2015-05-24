import React from 'react';
import Flux from './flux';
import FluxComponent from 'flummox/component';
import Router from 'react-router';
import PasokarasRoute from './routes/pasokaras_route.jsx';
import _ from 'lodash';

var flux = new Flux();

window.addEventListener("DOMContentLoaded", () => {
  flux.router.run((Handler, state) => {
    if (document.getElementById("app")) {
      React.render(
        <FluxComponent flux={flux}>
          <Handler />
        </FluxComponent>,
        document.getElementById("app"));
    }
  });
});

