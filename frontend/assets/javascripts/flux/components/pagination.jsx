import React from 'react';
import {Link} from 'react-router';
import _ from 'lodash';
import {getRouteNameFromPath} from '../route';

export default class Pagination extends React.Component {
  render() {
    let routeName = getRouteNameFromPath(this.props.flux.router.getCurrentPathname());

    if (_.isEmpty(this.props.meta))
      return <div />;

    return (
      <div className="pagination">
        <ul className="pagination">
          {this.firstLink(routeName)}
          {this.prevLink(routeName)}
          {this.pageLinks(routeName)}
          {this.nextLink(routeName)}
          {this.lastLink(routeName)}
        </ul>
      </div>
    );
  }

  prevLink(name) {
    if (this.props.meta.current_page !== 1) {
      return (
        <li>
          <Link to={name} query={this.pageQuery(-1)}>‹</Link>
        </li>
      );
    } else {
      return "";
    }
  }
  firstLink(name) {
    if (this.props.meta.current_page !== 1) {
      return (
        <li>
          <Link to={name} query={this.pageQueryStatic(1)}>«</Link>
        </li>
      );
    } else {
      return "";
    }
  }
  nextLink(name) {
    if (this.props.meta.current_page !== this.props.meta.total_pages) {
      return(
        <li>
          <Link to={name} query={this.pageQuery(1)}>›</Link>
        </li>
      );
    } else {
      return "";
    }
  }
  lastLink(name) {
    if (this.props.meta.current_page !== this.props.meta.total_pages) {
      return(
        <li>
          <Link to={name} query={this.pageQueryStatic(this.props.meta.total_pages)}>«</Link>
        </li>
      );
    } else {
      return "";
    }
  }
  pageLinks(name) {
    let meta = this.props.meta;
    let windowLimit = 6;

    let pages = [];
    pages.push(
      <li key="page-current" className="active">
        <a>{meta.current_page}</a>
      </li>
    );

    for (let i=1; 0 < (meta.current_page - i) && i <= windowLimit; ++i) {
      let key = `page-${meta.current_page - i}`
      pages.unshift(
        <li key={key}>
          <Link to={name} query={this.pageQuery(-i)}>
            {meta.current_page - i}
          </Link>
        </li>
      );

      if (0 < (meta.current_page - i) && i === windowLimit) {
        pages.unshift(
          <li key="backward-disabled" className="disabled">
            <a>...</a>
          </li>
        );

        pages.unshift(
          <li key="page-1">
            <Link to={name} query={this.pageQueryStatic(1)}>
              1
            </Link>
          </li>
        );
      }
    }

    for (let i=1; (meta.current_page + i) < meta.total_pages && i <= windowLimit; ++i) {
      let key = `page-${meta.current_page + i}`
      pages.push(

        <li key={key}>
          <Link to={name} query={this.pageQuery(i)}>
            {meta.current_page + i}
          </Link>
        </li>
      );

      if ((meta.current_page + i) < meta.total_pages && i === windowLimit) {
        pages.push(
          <li key="forward-disabled" className="disabled">
            <a>...</a>
          </li>
        );
        let lastPageKey = `page-${meta.total_pages}`
        pages.push(
          <li key={lastPageKey}>
            <Link to={name} query={this.pageQueryStatic(meta.total_pages)}>
              {meta.total_pages}
            </Link>
          </li>
        );
      }
    }

    return pages;
  }

  pageQuery(offset) {
    return Object.assign({}, this.props.flux.router.getCurrentQuery(), {page: this.props.meta.current_page + offset});
  }
  pageQueryStatic(pageNum) {
    return Object.assign({}, this.props.flux.router.getCurrentQuery(), {page: pageNum});
  }
}
