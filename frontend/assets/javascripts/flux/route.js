import React from 'react';
import Router from 'react-router';
import _ from 'lodash';
import PasokarasRoute from './routes/pasokaras_route.jsx';
import App from './routes/app.jsx';

var Route = Router.Route;

export var routes = (
  <Route name="app" path="/" handler={App}>
    <Route name="root" path="/" handler={PasokarasRoute} />
    <Route name="pasokaras" path="/pasokaras" handler={PasokarasRoute} />
    <Route name="favorites" path="/favorites" handler={PasokarasRoute} />
  </Route>
);

export function getRouteNameFromPath(path, targetRoutes = [routes]) {
  let route = _.find(targetRoutes, (r) => {
    return r.props.path === path
  });
  if (route)
    return route.props.name;

  let children = _(targetRoutes).map((r) => {return r.props.children})
    .flatten()
    .compact()
    .value();

  if (!_.isEmpty(children)) {
    return getRouteNameFromPath(path, children);
  } else {
    return null;
  }
}

