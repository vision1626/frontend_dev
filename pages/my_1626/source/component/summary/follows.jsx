import React from 'react';
import BaseComponent from '../../script/BaseClass.jsx';

class Follows extends BaseComponent {
  constructor() {
    super()
    this.state = { follows: {} }
  }

  loadFollowsFromServer() {
    $.ajax({
      url: this.props.url,
      dataType: 'json',
      cache: false,
      success: function(follows) {
        this.setState({follows: follows.data});
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(this.props.url, status, err.toString());
      }.bind(this)
    });
  }

  componentWillMount() {
    let self = this
    setTimeout(function() {
      self.loadFollowsFromServer()
    }, 1000)
  }

  render() {
    let rows = [];
    if (this.state.follows != {}) {
      for (var i = 0; i < this.state.follows.length; i++) {
        rows.push(<Follow follow={this.state.follows[i]} key={i}/>)
      }
    }
    return (
      <div className="follows">
        <h5>
          <i className="icon icon-news" />
          关注动态
        </h5>
        <table>
          <tbody>
            {rows}
          </tbody>
        </table>
      </div>
    )
  }
}

class Follow extends BaseComponent {
  render() {
    return (
      <tr>
        <td>
          <img src={this.props.follow.img} />
        </td>
        <td>
          <p>{this.props.follow.user_name}</p>
          <p>{decodeURIComponent(this.props.follow.title)}</p>
        </td>
      </tr>
    )
  }
}
export default Follows;