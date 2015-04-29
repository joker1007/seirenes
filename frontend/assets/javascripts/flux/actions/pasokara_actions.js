import { Actions } from 'flummox';
import request from 'superagent';

export default class PasokaraActions extends Actions {
  constructor(router) {
    super();
    this.router = router;
  }

  async load(path) {
    try {
      let res = await this.loadPasokara(path);
      return {
        pasokaras: res.body.pasokaras,
        meta: res.body.meta,
        facets: res.body.facets
      }
    } catch (e) {
      console.log(e);
      return {
        pasokaras: [],
        meta: {},
        facets: [],
      }
    }
  }

  loadPasokara(path) {
    return new Promise((resolve, reject) => {
      request.get(path)
        .set('Accept', 'application/json')
        .end((err, res) => {
          if (err)
            return reject(err);

          return resolve(res);
        });
    });
  }
}
