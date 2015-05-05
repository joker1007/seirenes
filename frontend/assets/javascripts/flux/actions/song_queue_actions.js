import { Actions } from 'flummox';
import request from 'superagent';
import getCsrfToken from '../get_csrf_token';

export default class SongQueueActions extends Actions {
  constructor() {
    super();
  }

  async load() {
    try {
      let res = await this._loadSongQueues();
      return res.body;
    } catch (e) {
      console.log(e);
      return null;
    }
  }

  async loadWithRandom(q) {
    let loadRes = await this.load();
    if (loadRes.length <= 1) {
      this.random(q);
    }
  }

  async random(q) {
    try {
      let res = await this._createRandomSongQueue(q);
      return res.body;
    } catch (e) {
      console.log(e);
      return null;
    }
  }

  async finish(id) {
    try {
      let res = await this._finishSongQueue(id);
      return res.body;
    } catch (e) {
      console.log(e);
      return null;
    }
  }

  _loadSongQueues() {
    return new Promise((resolve, reject) => {
      request.get('/song_queues')
        .set('Accept', 'application/json')
        .end((err, res) => {
          if (err)
            return reject(err);

          return resolve(res);
        });
    });
  }

  _finishSongQueue(id) {
    return new Promise((resolve, reject) => {
      request.put(`/song_queues/${id}`)
        .set('Accept', 'application/json')
        .set('X-CSRF-Token', getCsrfToken())
        .send({finish: true})
        .end((err, res) => {
          if (err)
            return reject(err);

          return resolve(res);
        });
    });
  }

  _createRandomSongQueue(q) {
    return new Promise((resolve, reject) => {
      request.post('/song_queues/random')
        .set('Accept', 'application/json')
        .set('X-CSRF-Token', getCsrfToken())
        .send({q: q})
        .end((err, res) => {
          if (err)
            return reject(err);

          return resolve(res);
        });
    });
  }
}
