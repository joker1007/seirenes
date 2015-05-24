import React from 'react';

export default class SearchField extends React.Component {
  constructor(props) {
    super(props);
    let q = this.props.flux.router.getCurrentQuery().q;
    this.state = {value: q};
  }

  handleChange(event) {
    this.setState({value: event.target.value});
  }

  search() {
    this.props.flux.router.transitionTo(this.context.routeName, {}, {q: this.state.value});
  }

  render() {
    return (
      <div id="search" className="form-inline">
        <input className="search form-control" type="text" name="q" placeholder="検索ワード" value={this.state.value} onChange={this.handleChange.bind(this)} />
        <button type="button" className="btn btn-default" onClick={this.search.bind(this)}>検索</button>
      </div>
    );
  }
}

SearchField.contextTypes = {
  routeName: React.PropTypes.string.isRequired
};
