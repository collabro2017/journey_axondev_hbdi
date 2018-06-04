import cx from 'classnames'
import {Link} from 'react-router-dom'

import React from 'react';
import styles from './video-nav.css'

import FontAwesomeIcon from '@fortawesome/react-fontawesome'
import {faArrowLeft} from '@fortawesome/fontawesome-free-solid'

export default function () {

  return (
    <>
      <Link to="/" className={styles.wrapper}>
      <FontAwesomeIcon icon={["fas","arrow-left"]}/>
      <p>&nbsp; Back</p>
      </Link>

    </>

  )
}
