import cx from 'classnames'
import {Link} from 'react-router-dom'
import {Profile} from 'axon-brand'
import {ProfilePolygon} from 'axon-brand'
import React from 'react';
import styles from '../saved-reports/saved-reports.css'
import TileMenu from '../tile-menu'
import logo from '../saved-reports/SVG/logo.svg'

export default function () {

  return (
    <>
      <TileMenu title="Your Saved Connections" />
        <br/>

      <div className={styles.pageWidth}>

      <h3>Your favorite connections</h3>
      <p>You can favorite up to three of your most-referenced connections here to have them appear as shortcuts on your dashboard tile.</p>

      <div className={cx(styles.wrapper, styles.saved)}>
        <div className={styles.savedProfile}>
           <img src={logo}/>
           <p>FName LName + John Smith<br/><b>Pair Report</b></p>
        </div>
      </div>

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

        <div className={styles.savedProfile}>
          <img src={logo}/>
          <p>ABC Company Dev Team<br/><b>Team Report</b></p>
        </div>

        <div className={styles.savedProfile}>
          <img src={logo}/>
          <p>ABC Company Management<br/><b>Team Report</b></p>
        </div>

      </div>

      </div>
    </>
  )
}
