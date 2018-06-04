import cx from 'classnames'
import FontAwesomeIcon from '@fortawesome/react-fontawesome'
import {faBell} from '@fortawesome/fontawesome-free-regular'
import React from 'react';
import TileMenu from '../tile-menu'
import styles from '../../styles.css'

export default function () {

  return (
    <div className={styles.tile}>
    <TileMenu title="Herrmann Announcements" />

    <div className={styles.noteWrap}>
    <div className={styles.bell}>
    <FontAwesomeIcon icon={["far","bell"]} />
    </div>

    <div className={cx(styles.notification, styles.new)}>
    <p>
    <span className={styles.small}> 3/16/18</span>
      This is a NEW notification. A different color will set it apart from older notifications, so the user knows there is something new to read. <a href="X">Learn More</a>
      </p>
    </div>
      </div>

    <div className={styles.notification}>
      <p>
        <span className={styles.small}> 3/5/18</span>
          This is an example of an OLD notification. <a href="X">Take the Tour</a>
      </p>
    </div>


    <p className={styles.small}>
      <a href="X">View past announcements</a>
    </p>

    </div>
  )
}
