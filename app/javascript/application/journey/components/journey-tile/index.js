import cx from 'classnames'
import React from 'react';
import {connect} from  'react-redux'
import {
  withRouter,
  Route,
  Link
} from 'react-router-dom'
import PropTypes from 'prop-types';
import JourneyTimeline from '../journey-timeline/';

import {selectTimelineData} from '../../selectors.js'

function JourneyTileContent(props){

  return (

  <JourneyTimeline {...props}/>

)
}

JourneyTileContent.propTypes = {
  completedEvents: PropTypes.arrayOf(
    PropTypes.shape({
      id: PropTypes.number.required,
      type: PropTypes.string.required,
      description: PropTypes.string.required,
      linkTo: PropTypes.string.required
    })
  ).isRequired
}

export default connect(selectTimelineData)(JourneyTileContent)
