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

  async enqueue(id) {
    try {
      let res = await this._createSongQueue(id);
      return res.body;
    } catch (e) {
      console.log(e);
      return null;
    }
  }

  async addToFavorite(id) {
    try {
      let res = await this._createFavorite(id);
      return res.body;
    } catch (e) {
      console.log(e);
      return null;
    }
  }

  async removeFromFavorite(id) {
    try {
      let res = await this._deleteFavorite(id);
      return res.body;
    } catch (e) {
      console.log(e);
      return null;
    }
  }

  changeOrderBy(routeName, currentQuery, orderBy) {
    let query = Object.assign({}, currentQuery, {page: 1, order_by: orderBy});
    this.router.transitionTo(routeName, {}, query);
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

  _createSongQueue(id) {
    return new Promise((resolve, reject) => {
      request.post(`/pasokaras/${id}/song_queues`)
        .set('Accept', 'application/json')
        .set('X-CSRF-Token', getCsrfToken())
        .end((err, res) => {
          if (err)
            return reject(err);

          toastr.success(`「${res.body.pasokara.title}」を予約に追加しました`);
          return resolve(res);
        });
    });
  }

  _createFavorite(id) {
    return new Promise((resolve, reject) => {
      request.post(`/pasokaras/${id}/favorite`)
        .set('Accept', 'application/json')
        .set('X-CSRF-Token', getCsrfToken())
        .end((err, res) => {
          if (err)
            return reject(err);

          toastr.success(`「${res.body.pasokara.title}」をお気に入りに追加しました`);
          return resolve(res);
        });
    });
  }


  _deleteFavorite(id) {
    return new Promise((resolve, reject) => {
      request.del(`/pasokaras/${id}/favorite`)
        .set('Accept', 'application/json')
        .set('X-CSRF-Token', getCsrfToken())
        .end((err, res) => {
          if (err)
            return reject(err);

          toastr.success(`「${res.body.pasokara.title}」をお気に入りから削除しました`);
          return resolve(res);
        });
    });
  }
}
