import { Store } from 'flummox';
import Immutable from 'immutable';

export default class CurrentFilterTagsStore extends Store {
  constructor(flux) {
    super();

    const filterActionIds = flux.getActionIds('filter_tags');
    this.register(filterActionIds.init, this.handleInit);
    this.register(filterActionIds.add, this.handleAdd);
    this.register(filterActionIds.remove, this.handleRemove);

    this.state = {
      filterTags: Immutable.List()
    };
  }

  getTags() {
    return this.state.filterTags;
  }

  handleInit(tags) {
    this.setState({filterTags: Immutable.List(tags)});
  }

  handleAdd(tag) {
    let newFilterTags = this.state.filterTags.push(tag);
    this.setState({filterTags: newFilterTags});
  }
}
