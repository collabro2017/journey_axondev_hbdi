import { Provider } from 'react-redux'
import DevTools from '../dev-tools'
import React from 'react';
import { BrowserRouter as Router } from 'react-router-dom'
import App from '../containers/app'

export default class Root extends React.Component {
  render() {
    const store  = this.props.store;

    return (
      <Provider store={store}>
        <>
          <Router basename={this.props.base}>
            <App />
          </Router>
          <DevTools />
        </>
      </Provider>
    );
  }
}
