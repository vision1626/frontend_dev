import React from 'react';
import {render} from 'react-dom';
import AwesomeComponent from '../component/AwesomeComponent.jsx';
import CTwo from '../component/cTwo.jsx';

class Index extends React.Component {
  render () {
    return (
      <div>
        <AwesomeComponent />
        <CTwo />
      </div>
    );
  }
}

render(
  <Index/>,
  document.getElementById('wrapper')
);