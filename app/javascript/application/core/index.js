import React from 'react';
import ReactDom from 'react-dom'
import configureStore from './store'
import Root from './root'

const store = configureStore({})

export function init(opts){
  ReactDom.render(
    <Root store={store} base={opts.base} />,
    document.getElementById('root')
  );
}
