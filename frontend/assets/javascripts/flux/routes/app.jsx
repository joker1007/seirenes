import React from 'react';
import FluxComponent from 'flummox/component';
import {RouteHandler} from 'react-router';

export default class App extends React.Component {
  render() {
    return (
      <FluxComponent>
        <RouteHandler />
      </FluxComponent>
    );
  }
}
