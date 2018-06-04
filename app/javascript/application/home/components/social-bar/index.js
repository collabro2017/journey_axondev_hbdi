import React from 'react';

import styles from '../../styles.css'

import fontawesome from '@fortawesome/fontawesome'

import FontAwesomeIcon from '@fortawesome/react-fontawesome'

import { faEnvelopeSquare, faUserCircle, faBell, faArrowAltCircleDown } from '@fortawesome/fontawesome-free-regular'

import brands from '@fortawesome/fontawesome-free-brands'

export default function () {

  return (
    <div className={styles.socialWrapper}>

      <div className={styles.socialIcons}>
        <FontAwesomeIcon icon={["far","arrow-alt-circle-down"]}/>
        </div>

      <div className={styles.socialIcons}>
        <FontAwesomeIcon icon={["far","envelope"]}/>
      </div>

      {/*<div className={styles.socialIcons}>
        <FontAwesomeIcon icon={["fab","linkedin"]}/>
      </div>

      <div className={styles.socialIcons}>
        <FontAwesomeIcon icon={["fab","facebook-square"]}/>
      </div>

      <div className={styles.socialIcons}>
        <FontAwesomeIcon icon={["fab","twitter-square"]}/>
      </div> */}

  </div>
  )
}
