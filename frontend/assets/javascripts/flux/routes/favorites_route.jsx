import React from 'react';
import PasokarasRoute from './pasokaras_route.jsx';

export default class FavoritesRoute extends PasokarasRoute {
  getChildContext() {
    return {routeName: 'favorites'};
  }
}

FavoritesRoute.childContextTypes = {
  routeName: React.PropTypes.string.isRequired
};
