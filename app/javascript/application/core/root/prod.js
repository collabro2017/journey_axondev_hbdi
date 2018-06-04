import { Provider } from 'react-redux'
import React from 'react';
import { BrowserRouter as Router } from 'react-router-dom'
import App from '../containers/app'

export default class Root extends React.Component {
    getChildContext(){
    return {printing: this.props.printing}
  }

  render() {
    const  store = this.props.store;
    const history = this.props.history
    const routes = this.props.routes

    return (
      <Provider store={store}>
        <Router basename={this.props.base}>
          < App />
        </Router>
      </Provider>
    );
  }
}
