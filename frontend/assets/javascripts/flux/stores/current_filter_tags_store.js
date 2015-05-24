import { Store } from 'flummox';
import { Set } from 'immutable';

export default class CurrentFilterTagsStore extends Store {
  constructor(flux) {
    super();

    const filterActionIds = flux.getActionIds('filter_tags');
    this.register(filterActionIds.init, this.handleInit);

    this.state = {
      filterTags: Set()
    };
  }

  getTags() {
    return this.state.filterTags;
  }

  handleInit(tags) {
    if (tags) {
      this.setState({filterTags: Set(tags)});
    }
  }
}
