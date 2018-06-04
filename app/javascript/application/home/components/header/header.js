import cx from 'classnames'
import FontAwesomeIcon from '@fortawesome/react-fontawesome'
import {faUserCircle} from '@fortawesome/fontawesome-free-regular'
import logo from '../../images/logo.png'
import React from 'react';
import styles from '../../styles.css'
import {
  BrowserRouter as Router,
  Route,
  Link
} from 'react-router-dom'

export default function () {

  return (
    <div className={styles.header}>

    <Link to="/" className={styles.logo}><img src={logo}/></Link>

    <h3>Welcome, FName!</h3>

    <div className={styles.userSettings}>
    <FontAwesomeIcon icon={["far","user-circle"]}/>
    </div>

    </div>
  )
}
