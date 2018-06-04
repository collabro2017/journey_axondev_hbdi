import cx from 'classnames'
import React from 'react';
import {connect} from  'react-redux'
import {
  withRouter,
  Route,
  Link
} from 'react-router-dom'
import PropTypes from 'prop-types';
import styles from './journey.css';

export default function registeredRender(e){

  return (
    <div key={e.id} className={styles.event}>
      <a>
        {e.icon}
          <br/>
        {e.description} {e.date}
      </a>
    </div>
  )
}

const imageMap = {
  thinker_registered: registeredRender,
  thinker_profile_generated: (e) => {
    return (
      <div key={e.id} className={styles.event}>
        <a>
        {e.icon}
          <br/>
        {e.description} {e.date}
        </a>
      </div>
    )
  },

  thinker_profile_unlocked: (e) => {
    return (
      <div key={e.id} className={styles.event}>
        <a>
        {e.icon}
          <br/>
        {e.description} {e.date} </a>
      </div>
    )
  },

  thinker_debriefed: (e) => {
    return (
      <div key={e.id} className={styles.event}>
        <a>
          {e.icon}
            <br/>
          {e.description} {e.date}
        </a>
      </div>
    )
  },

  resource_library: (e) => {
    return (
      <div key={e.id} className={styles.event}>
        <a>
          {e.icon}
            <br/>
          {e.description} {e.date}
        </a>
      </div>
    )
  },

  connect_team: (e) => {
    return (
      <div key={e.id} className={styles.event}>
        <a>
          {e.icon}
            <br/>
          {e.description} {e.date}
        </a>
      </div>
    )
  },

  invite: (e) => {
    return (
      <div key={e.id} className={styles.event}>
        <a>
          {e.icon}
            <br/>
        {e.description} {e.date}
        </a>
      </div>
    )
  }
}
