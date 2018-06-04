import cx from 'classnames'
import {Link} from 'react-router-dom'

import {Profile} from 'axon-brand'
import {ProfilePolygon} from 'axon-brand'
import React from 'react';
import SocialBar from '../social-bar'
import styles from '../../styles.css'
import TileMenu from '../tile-menu'
import Tile from '../tile'

export default function () {

  return (
      < >

      <TileMenu title="Your Results" />

      <h4>FName LName</h4>

      <div className={styles.resultsMap}>
        <svg viewBox="0 0 100 100" width="100%">
           <Profile />
           <ProfilePolygon strokeWidth={1} scores={{A: 55, B: 40, C: 75, D: 104}} />
        </svg>
      </div>

      <div className={styles.button}>
        <Link to="/profile">Your Profile Overview</Link>
      </div>

      <div className={styles.button}>
        Explore the Digital Profile Pack
      </div>

      <div className={styles.button}>
        Learn About the HBDI
      </div>

      <SocialBar/>

      </>
  )
}
