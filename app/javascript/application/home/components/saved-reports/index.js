import cx from 'classnames'
import {Link} from 'react-router-dom'
import {Profile} from 'axon-brand'
import {ProfilePolygon} from 'axon-brand'
import React from 'react';
import styles from './saved-reports.css'
import TileMenu from '../tile-menu'
import logo from './SVG/logo.svg'


export default function () {

  return (
    <>
      <TileMenu title="Your Connections" />
        <br/>

      <div className={cx(styles.wrapper, styles.profiles)}>

        <div className={styles.savedProfile}>
           <img src={logo}/>
           <p>FName LName + John Smith<br/><b>Pair Report</b></p>
        </div>

        <div className={styles.savedProfile}>
          <img src={logo}/>
          <p>ABC Company Dev Team<br/><b>Team Report</b></p>
        </div>

        <div className={styles.savedProfile}>
          <img src={logo}/>
          <p>ABC Company Management<br/><b>Team Report</b></p>
        </div>

      </div>

      <div className={styles.searchBar}>
        <input type="text" placeholder="Find a connection"/>
        <button className={styles.searchButton} type="submit">
          Search
        </button>
      </div>

      <Link to="/savedreports">
        <p className={styles.small}>See all connections and select favorites</p>
      </Link>
    </>
  )
}
