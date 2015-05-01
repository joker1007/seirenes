import { Actions } from 'flummox';

export default class FilterTagActions extends Actions {
  constructor() {
    super();
  }

  add(tag) {
    return tag;
  }

  remove(tag) {
    return tag;
  }

  init(tags) {
    return tags;
  }
}
