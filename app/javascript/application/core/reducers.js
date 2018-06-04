import { combineReducers } from 'redux'
import _ from 'lodash'

const reducer = (combineReducers(Object.assign({}, {
  app: (previousState, action) => {return previousState || {}}
})))

export default reducer
