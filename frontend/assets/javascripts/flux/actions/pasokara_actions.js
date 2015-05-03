import { Actions } from 'flummox';
import _ from 'lodash';
import request from 'superagent';
import getCsrfToken from '../get_csrf_token';

export default class PasokaraActions extends Actions {
  constructor(router) {
    super();
    this.router = router;
  }

  async load(path) {
    try {
      let res = await this._loadPasokaras(path);
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

  async loadSingle(id) {
    try {
      let res = await this._loadSinglePasokara(id);
      return res.body;
    } catch (e) {
      console.log(e);
      return null;
    }
  }

  changeOrderBy(orderBy) {
    let currentRouteName = _.last(this.router.getCurrentRoutes()).name;
    let query = Object.assign({}, this.router.getCurrentQuery(), {page: 1, order_by: orderBy});
    this.router.transitionTo(currentRouteName, {}, query);
  }

  async encode(id) {
    try {
      let res = await this._encodeRequest(id);
      let checker = () => {
        setTimeout(async () => {
          let {id: _id, movie_url, progress} = await this._checkEncodeProgress(id);
          if (!movie_url) {
            this.updateProgress(id, progress);
            checker();
          } else {
            this.updateMovieUrl(id, movie_url);
          }
        }, 3000);
      };
      checker();
      return id;
    } catch (e) {
      console.log(e);
      return null;
    }
  }

  updateProgress(id, progress) {
    return {id: id, progress: progress};
  }

  updateMovieUrl(id, movie_url) {
    return {id: id, movie_url: movie_url};
  }

  async _checkEncodeProgress(id) {
    try {
      let res = await this._fetchEncodeProgress(id);
      return Object.assign({}, res.body, {id: id});
    } catch (e) {
      console.log(e);
      return null;
    }
  }

  _loadPasokaras(path) {
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

  _loadSinglePasokara(id) {
    return new Promise((resolve, reject) => {
      request.get(`/pasokaras/${id}`)
        .set('Accept', 'application/json')
        .end((err, res) => {
          if (err)
            return reject(err);

          return resolve(res);
        });
    });
  }

  _encodeRequest(id) {
    return new Promise((resolve, reject) => {
      request.post(`/pasokaras/${id}/encoding`)
        .set('Accept', 'application/json')
        .set('X-CSRF-Token', getCsrfToken())
        .end((err, res) => {
          if (err)
            return reject(err);

          return resolve(res);
        });
    });
  }

  _fetchEncodeProgress(id) {
    return new Promise((resolve, reject) => {
      setTimeout(() => {
        request.get(`/pasokaras/${id}/encoding`)
          .set('Accept', 'application/json')
          .end((err, res) => {
            if (err)
              return reject(err);

            return resolve(res);
          });
      }, 3000);
    });
  }
}
