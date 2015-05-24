import React from 'react';
import Router from 'react-router';
import _ from 'lodash';
import PasokarasRoute from './routes/pasokaras_route.jsx';
import FavoritesRoute from './routes/favorites_route.jsx';
import PasokaraShowRoute from './routes/pasokara_show_route.jsx';
import PlayerRoute from './routes/player_route.jsx';
import PartyRoute from './routes/party_route.jsx';
import App from './routes/app.jsx';

var {Route, Redirect} = Router;

export var routes = (
  <Route name="app" path="/" handler={App}>
    <Redirect from="/" to="pasokaras" />
    <Route name="pasokaras" path="/pasokaras" handler={PasokarasRoute} />
    <Route name="favorites" path="/favorites" handler={FavoritesRoute} />
    <Route name="pasokara_show" path="/pasokaras/:pasokaraId" handler={PasokaraShowRoute} />
    <Route name="player" path="/player" handler={PlayerRoute} />
    <Route name="party" path="/party" handler={PartyRoute} />
  </Route>
);
