import React from 'react';
import FluxComponent from 'flummox/component';

export default class SortForm extends React.Component {
  render() {
    return(
      <div id="sort-field">
        <div className="form-inline">
          <FluxComponent>
            <SortFormSelect />
          </FluxComponent>
        </div>
      </div>
    );
  }
}

class SortFormSelect extends React.Component {
  constructor(props) {
    super(props);
    let currentOrderBy = this.props.flux.router.getCurrentQuery().order_by || "created_at desc"
    console.log(this);
    this.state =  {
      value: currentOrderBy
    };
  }

  handleChange(event) {
    this.setState({value: event.target.value});
    this.props.flux.getActions('pasokaras').changeOrderBy(event.target.value);
  }

  render() {
    return(
      <select name="order_by" id="order_by" className="form-control" value={this.state.value} onChange={this.handleChange.bind(this)}>
        <option value="created_at desc">追加日(新しい順)</option>
        <option value="created_at asc">追加日(古い順)</option>
        <option value="nico_posted_at desc">投稿日(新しい順)</option>
        <option value="nico_posted_at asc">投稿日(古い順)</option>
        <option value="raw_title asc">タイトル(昇順)</option>
        <option value="raw_title desc">タイトル(降順)</option>
        <option value="nico_mylist_count desc">マイリスト(多い順)</option>
        <option value="nico_mylist_count asc">マイリスト(少ない順)</option>
      </select>
    );
  }
}

